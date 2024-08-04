import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/core/theme/consts.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/models/contract_model.dart';
import 'package:mostaql/models/global_response_model.dart';
import 'package:mostaql/models/user_model.dart';
import 'package:mostaql/parameters/filter_paramaters.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:mostaql/repos/lang_repo.dart';

import '../app_config.dart';
import '../core/localization/loc_keys.dart';
import '../core/utils/translation_helper.dart';
import '../core/utils/vaildData/valid_data.dart';
import '../models/uploaded_contact_data.dart';
import '../parameters/contact_paramaters.dart';

class ContractRepo {
  final ApiHelper apiHelper;
  final LangRepo langRepo;
  final CacheHelper cacheHelper;
  final AuthRepo authRepo;

  UserData? user;

  ContractRepo(
    this.apiHelper,
    this.langRepo,
    this.cacheHelper,
    this.authRepo,
  );

  bool hasContactsPermission = false;
  List<Contact> contactList = [];
  List<Contact> searchInUserContactList = [];
  List<UploadedContractData> uploadContactList = [];
  int page = 1;
  List<ContactData> paginationList = [];

  ContactModel? unCompletedContactModel;
  GlobalResponseModel? storedUploadContactsModel;
  Set<int> paginatedContactIds = {};
  ContactModel? searchContactsModel;
  ContactModel? userContactsModel;
  int? totalUserContacts;

  Future<Either<String, List<ContactData>>> searchContract({FilterParameters? filterParameters}) async {
    try {
      var response = await apiHelper.getData(
        EndPoints.searchContracts(page: page, perPage: 5, filterParameters: filterParameters),
        lang: langRepo.lang,
        token: authRepo.token,
        typeJSON: true,
      );
      final data = jsonDecode(response);
      ContactModel contractModel = ContactModel.fromJson(data);
      searchContactsModel = contractModel;
      if (validString(
        contractModel.showError(),
      )) {
        return Left(contractModel.showError());
      } else {
        page = page + 1;
        for (var element in contractModel.contractData) {
          if (!paginatedContactIds.contains(element.id)) {
            paginatedContactIds.add(element.id);
            paginationList.add(element);
          }
        }
        debugPrint('${paginationList.length} ==================>');
      }

      return Right(paginationList);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<Either<String, List<Contact>>> getAllUserContact() async {
    hasContactsPermission = await FlutterContacts.requestPermission();
    if (hasContactsPermission) {
      contactList = await FlutterContacts.getContacts(withProperties: true, withPhoto: true, withThumbnail: true);
      return Right(contactList);
    } else {
      return Left(Loc.accessDenied());
    }
  }

  Future<Either<String, GlobalResponseModel>> uploadContactsToDataBase({bool? uploadNewContracts}) async {
    try {
      if (storedUploadContactsModel == null || uploadNewContracts != null) {
        uploadContactList = contactList
            .where((element) => element.phones.isNotEmpty && element.displayName.isNotEmpty)
            .map(
              (e) => UploadedContractData(
                name: e.displayName,
                phone: e.phones
                    .firstWhere((element) => element.number.isNotEmpty)
                    .number
                    .replaceAll(RegExp(r'[^0-9]'), ''),
                job: e.organizations.isNotEmpty ? e.organizations.first.title : null,
                tags: e.groups.isNotEmpty ? e.groups.map((e) => e.name).toList().join() : null,
                gender: null,
                placeOfBirth: null,
                placeOfWork: null,
              ),
            )
            .toList();
        List<Map<String, dynamic>> contactMaps = uploadContactList.map((contact) => contact.toJson()).toList();
        var response =
            await apiHelper.postData(EndPoints.uploadContact, data: {'data': contactMaps}, token: authRepo.token);
        debugPrint('${contactMaps.length} Uploaded Length');
        final data = jsonDecode(response);
        GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);
        storedUploadContactsModel = globalResponseModel;
        if (validString(
          storedUploadContactsModel!.showError(),
        )) {
          return Left(
            storedUploadContactsModel!.showError(),
          );
        }
      }

      return Right(storedUploadContactsModel!);
    } catch (e, s) {
      log(
        e.toString(),
      );
      log(
        s.toString(),
      );
      return Left(
        getServerError(),
      );
    }
  }

  Future<Either<String, List<Contact>>> searchInUserContact({required String contactName}) async {
    if (contactList.isEmpty) {
      debugPrint('contactList is Empty');
      await getAllUserContact();
    }
    searchInUserContactList.clear();
    for (var element in contactList) {
      if (element.displayName.toLowerCase().contains(
            contactName.toLowerCase(),
          )) {
        searchInUserContactList.add(element);
      }
    }
    if (searchInUserContactList.isEmpty) {
      return Left(
        Loc.searchIsEmpty(),
      );
    } else {
      return Right(searchInUserContactList);
    }
  }

  Future<Either<String, ContactModel>> getUnCompletedContacts() async {
    try {
      var response = await apiHelper.getData(
        EndPoints.unCompletedContact,
        lang: langRepo.lang,
        token: authRepo.token,
        typeJSON: true,
      );

      final data = jsonDecode(response);
      ContactModel contractModel = ContactModel.fromJson(data);
      unCompletedContactModel = contractModel;
      if (validString(contractModel.showError())) {
        return Left(contractModel.showError());
      }

      return Right(unCompletedContactModel!);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<Either<String, GlobalResponseModel>> addPersonToDataBase(
      {required ContactParameters addPersonParameters}) async {
    try {
      Map<String, dynamic> params = {
        "name": addPersonParameters.name,
        "phone": addPersonParameters.phone,
        "email": addPersonParameters.email,
        "job": addPersonParameters.job,
        "tags": addPersonParameters.tags,
        "gender": addPersonParameters.gender,
        "place_of_birth": addPersonParameters.placeOfBirth,
        "place_of_work": addPersonParameters.placeOfWork,
        "notes": addPersonParameters.notes,
        "phone_code": addPersonParameters.phoneCode ?? getInitialCountry.phoneCode
      };
      params = removeNullAndEmptyParams(params);
      var response = await apiHelper.postData(EndPoints.addContracts,
          lang: langRepo.lang, typeJSON: true, token: authRepo.token, data: params);

      final data = jsonDecode(response);
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);

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

  Map<String, dynamic> removeNullAndEmptyParams(Map<String, dynamic> original) {
    return original..removeWhere((key, value) => value == null || (value is String && value.isEmpty));
  }

  Future<Either<String, GlobalResponseModel>> updateContact({
    required ContactParameters addPersonParameters,
  }) async {
    try {
      Map<String, dynamic> params = {
        "name": addPersonParameters.name,
        "phone": addPersonParameters.phone,
        "email": addPersonParameters.email,
        "job": addPersonParameters.job,
        "tags": addPersonParameters.tags,
        "gender": addPersonParameters.gender,
        "place_of_birth": addPersonParameters.placeOfBirth,
        "place_of_work": addPersonParameters.placeOfWork,
        "notes": addPersonParameters.notes,
      };
      params = removeNullAndEmptyParams(params);
      var response = await apiHelper.postData(
        EndPoints.updateContracts(
          id: addPersonParameters.id!,
        ),
        lang: langRepo.lang,
        typeJSON: true,
        token: authRepo.token,
        data: params,
      );

      final data = jsonDecode(response);
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);

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

  Future<Either<String, GlobalResponseModel>> deleteContact({required int id}) async {
    try {
      var response = await apiHelper.deleteData(
        EndPoints.updateContracts(id: id),
        lang: langRepo.lang,
        typeJSON: true,
        token: authRepo.token,
      );

      final data = jsonDecode(response);
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);

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

  Future<Either<String, List<ContactData>>> getUserContactFromDataBase(FilterParameters? filterParameters) async {
    try {
      var response = await apiHelper.getData(
        EndPoints.getUserContactsFromDataBase(page: page, perPage: 5, filterParameters: filterParameters),
        lang: langRepo.lang,
        token: authRepo.token,
        typeJSON: true,
      );
      final data = jsonDecode(response);
      ContactModel contractModel = ContactModel.fromJson(data);

      if (filterParameters!.isAnyParameterEmpty()) {
        userContactsModel = contractModel;
      }
      if (validString(
        contractModel.showError(),
      )) {
        return Left(contractModel.showError());
      } else {
        page = page + 1;
        for (var element in contractModel.contractData) {
          if (!paginatedContactIds.contains(element.id)) {
            paginatedContactIds.add(element.id);
            paginationList.add(element);
          }
        }
        debugPrint('${paginationList.length} ==================>');
      }
      return Right(paginationList);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<Either<String, GlobalResponseModel>> deleteMultiContacts(List<int> ids) async {
    try {
      var response = await apiHelper.deleteData(
        EndPoints.deleteManyContacts(contactIds: ids),
        lang: langRepo.lang,
        typeJSON: true,
        token: authRepo.token,
      );
      final data = jsonDecode(response);
      GlobalResponseModel globalResponseModel = GlobalResponseModel.fromJson(data);
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
}
