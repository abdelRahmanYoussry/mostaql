import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mostaql/core/utils/translation_helper.dart';
import 'package:mostaql/models/global_response_model.dart';

import '../app_config.dart';
import '../core/cache/cache_helper.dart';
import '../core/localization/loc_keys.dart';
import '../core/utils/remote/api_helper.dart';
import '../core/utils/remote/failure.dart';
import '../core/utils/vaildData/valid_data.dart';
import '../models/friend_connection_response.dart';
import 'auth_repo.dart';
import 'lang_repo.dart';

abstract class ConnectionsRepo {
  Future<Either<Failure, FriendConnectionResponse>> getFriendConnections({required bool getNewData});

  Future<Either<Failure, void>> shareConnection(String phone);

  Future<Either<String, GlobalResponseModel>> deleteFriendConnections(int id);
}

class ConnectionsRepoImpl implements ConnectionsRepo {
  final ApiHelper apiHelper;
  final LangRepo langRepo;
  final CacheHelper cacheHelper;

  final AuthRepo authRepo;

  ConnectionsRepoImpl(
    this.apiHelper,
    this.langRepo,
    this.cacheHelper,
    this.authRepo,
  );

  FriendConnectionResponse? friendConnectionResponse;
  File? profileImageFile;
  var picker = ImagePicker();

  @override
  Future<Either<Failure, FriendConnectionResponse>> getFriendConnections({required bool getNewData}) async {
    try {
      if (getNewData || friendConnectionResponse == null) {
        final response = await apiHelper.getData(
          EndPoints.getFriendConnections,
          token: authRepo.token, // token,
          lang: langRepo.lang,
          typeJSON: true,
        );

        final decodedResponse = jsonDecode(response);
        final data = FriendConnectionResponse.fromJson(decodedResponse);
        friendConnectionResponse = data;
        if (validString(
          data.showError(),
        )) {
          return Left(
            data.showError(),
          );
        }
      }
      return Right(friendConnectionResponse!);
    } catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> shareConnection(String phone) async {
    try {
      final response = await apiHelper.postData(
        EndPoints.getFriendConnections, //
        token: authRepo.token, // token,
        lang: langRepo.lang,
        typeJSON: true,
        data: {'phone': phone},
      );

      final decodedResponse = jsonDecode(response);
      if (decodedResponse['error'] == false) {
        return const Right(null);
      } else {
        return Left(
          Failure(
            decodedResponse['message'] ?? Loc.server_key(),
          ),
        );
      }
    } catch (e) {
      return Left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<String, GlobalResponseModel>> deleteFriendConnections(int id) async {
    try {
      var response = await apiHelper.deleteData(EndPoints.deleteFriendConnections(id),
          token: authRepo.token, typeJSON: true, lang: langRepo.lang);
      final data = jsonDecode(response);
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);
      if (validString(
        globalResponseModel.showError(),
      )) {
        return Left(
          globalResponseModel.showError(),
        );
      }
      return Right(globalResponseModel);
    } catch (e, s) {
      log(
        e.toString(),
      );
      log(
        s.toString(),
      );
      return Left(getServerError());
    }
  }
}
