import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaql/app_config.dart';
import 'package:mostaql/core/app/app_bloc.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/core/utils/notifications/setup_notifications.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/core/utils/translation_helper.dart';
import 'package:mostaql/core/utils/vaildData/valid_data.dart';
import 'package:mostaql/models/global_response_model.dart';
import 'package:mostaql/models/user_model.dart';
import 'package:mostaql/repos/lang_repo.dart';

import '../core/localization/loc_keys.dart';
import '../core/utils/pick_image_utils.dart';
import '../core/utils/remote/dio_helper.dart';
import '../core/utils/remote/failure.dart';
import '../models/about_app_model.dart';
import '../models/pickup_image_model.dart';
import '../models/recently_profile_photos_model.dart';

class AuthRepo {
  final ApiHelper apiHelper;
  final DioHelper dioHelper;
  final LangRepo langRepo;
  final SetupFCM setupFCM;
  final CacheHelper cacheHelper;
  final FirebaseAuth firebaseAuth;
  UserData? user;
  String? token;
  File? profileImageFile;
  var picker = ImagePicker();
  AboutAppModel? repoAboutAppModel;

  AuthRepo(this.apiHelper, this.langRepo, this.setupFCM, this.cacheHelper, this.firebaseAuth, this.dioHelper);

  Future<Either<String, void>> logout() async {
    try {
      await apiHelper.postData(
        EndPoints.logout,
        token: user!.token,
        lang: langRepo.lang,
        typeJSON: true,
      );
      _removeUser();
      return const Right(null);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<Either<String, UserModel>> loginWithDataBase({
    required String phone,
  }) async {
    try {
      var response = await apiHelper.postData(
        EndPoints.loginWithDataBase,
        lang: langRepo.lang,
        typeJSON: true,
        data: {
          "phone": phone,
        },
      );

      final data = jsonDecode(response);
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);
      UserModel userModel = UserModel.fromJson(data);
      if (validString(globalResponseModel.showError())) {
        return Left(globalResponseModel.showError());
      }
      if (userModel.userData.token.isNotEmpty) {
        _saveUser(userModel, true);
      }
      return Right(userModel);
    } catch (e, s) {
      log('$e e.strng');
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<void> firebaseSendOtpCodeToUserNew(
      {required String phone,
      required PhoneCodeSent codeSent,
      required PhoneVerificationFailed verificationFailed}) async {
    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) {},
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  Future<Either<String, UserCredential>> firebaseCheckOtpNew(
      {required String otp, required String verificationId}) async {
    AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp);
    UserCredential? firebaseUserCredential;
    String firebaseError = '';
    firebaseAuth.signInWithCredential(credential).then((value) {
      if (value.user != null) {
        firebaseUserCredential = value;
      }
    }).catchError((error) {
      debugPrint(
        error.toString(),
      );
      firebaseError = error.toString();
    });
    if (firebaseUserCredential != null) {
      return Right(firebaseUserCredential!);
    } else {
      return Left(firebaseError);
    }
  }

  Future<Either<String, GlobalResponseModel>> updateUserWithDataBase({String? name, File? photo, int? avatarId}) async {
    try {
      final Map<String, dynamic> data = {};

      if (name != null) {
        data["name"] = name;
      }

      if (photo != null) {
        data["photo"] = await prepareImageForUpload(photo);
      }
      if (avatarId != null) {
        data['avatar_id'] = avatarId;
      }
      FormData formData = FormData.fromMap(data);

      var response = await dioHelper.postMultiPart(
        EndPoints.updateUserWithDataBase,
        token: token!, // token,
        data: formData,
      );
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(response);
      if (validString(globalResponseModel.showError())) {
        return Left(globalResponseModel.showError());
      }

      return Right(globalResponseModel);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  _saveUser(UserModel? userModel, [bool rememberMe = true]) async {
    debugPrint('AuthRepo._saveUser');
    user = userModel!.userData;
    token = user!.token;
    await cacheHelper.put(kUserToken, token);
    await AppBloc().loggedIn(user!);
    if (rememberMe) {
      await cacheHelper.put(kUserKey, user!.toJson());
    }
  }

  _removeUser() async {
    user = null;
    token = null;
    await AppBloc().loggedOut();
    await cacheHelper.clear(kUserKey);
  }

  Future<bool> checkUser() async {
    final userJson = await cacheHelper.get(kUserKey);
    if (userJson == null) {
      return false;
    }
    // todo get user from server
    user = UserData.fromJson(userJson);
    token = await cacheHelper.get(kUserToken);
    await AppBloc().loggedIn(user!);
    return true;
  }

  Future<Either<Failure, UserData>> getProfile({required bool getNewData}) async {
    try {
      if (user == null || getNewData) {
        final response = await apiHelper.getData(
          EndPoints.getProfile,
          lang: langRepo.lang,
          typeJSON: true,
          token: token,
        );
        UserModel userModel = UserModel.fromJson(jsonDecode(response));
        user = userModel.userData;
        if (validString(
          userModel.showError(),
        )) {
          return Left(
            userModel.showError(),
          );
        }
      }
      return Right(user!);
      // if (userModel.error == false) {
      //   return Right(user!);
      // } else {
      //   return Left(Failure(userModel.errors!));
      // }
    } catch (e) {
      return Left(Failure(getServerError()));
    }
  }

  Future<Either<String, PickUpImageModel>> pickUpGalleryImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      debugPrint('${pickedFile.path}   Path');
      return Right(PickUpImageModel(profileImageFile, pickedFile.path));
    } else {
      return Left(Loc.noImageSelected());
    }
  }

  Future<Either<Failure, RecentlyProfilePhotosModel>> getRecentlyProfileImages() async {
    try {
      final response = await apiHelper.getData(
        EndPoints.getRecentlyProfileImages,
        lang: langRepo.lang,
        typeJSON: true,
        token: token,
      );
      RecentlyProfilePhotosModel recentlyProfilePhotos = RecentlyProfilePhotosModel.fromJson(jsonDecode(response));

      if (validString(
        recentlyProfilePhotos.showError(),
      )) {
        return Left(
          recentlyProfilePhotos.showError(),
        );
      }

      return Right(recentlyProfilePhotos);
    } catch (e) {
      return Left(Failure(getServerError()));
    }
  }

  Future<Either<Failure, AboutAppModel>> getAboutAppInfo() async {
    try {
      if (repoAboutAppModel == null) {
        final response = await apiHelper.getData(
          EndPoints.aboutApp,
          lang: langRepo.lang,
          typeJSON: true,
          token: token,
        );
        AboutAppModel aboutAppModel = AboutAppModel.fromJson(jsonDecode(response));
        repoAboutAppModel = aboutAppModel;
        if (validString(
          aboutAppModel.showError(),
        )) {
          return Left(
            aboutAppModel.showError(),
          );
        }
      }
      return Right(repoAboutAppModel!);
    } catch (e) {
      debugPrint(e.toString() + 'lllll');
      return Left(Failure(getServerError()));
    }
  }
}
