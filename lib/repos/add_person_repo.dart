import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/core/utils/notifications/setup_notifications.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/models/citiess_model.dart';
import 'package:mostaql/models/countries_model.dart';
import 'package:mostaql/models/place_of_work_model.dart';
import 'package:mostaql/models/states_model.dart';
import 'package:mostaql/models/user_model.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:mostaql/repos/lang_repo.dart';

import '../app_config.dart';
import '../core/utils/translation_helper.dart';
import '../core/utils/vaildData/valid_data.dart';

class AddPersonRepo {
  final ApiHelper apiHelper;
  final LangRepo langRepo;
  final SetupFCM setupFCM;
  final CacheHelper cacheHelper;
  final AuthRepo authRepo;

  AddPersonRepo(this.apiHelper, this.langRepo, this.setupFCM, this.cacheHelper, this.authRepo);
  CountriesModel? repoCountriesModel;
  Future<Either<String, CountriesModel>> getCountriesFromDataBase() async {
    try {
      if (repoCountriesModel == null) {
        var response = await apiHelper.getData(
          EndPoints.countries,
          lang: langRepo.lang,
          typeJSON: true,
          token: authRepo.token,
        );

        final data = jsonDecode(response);
        CountriesModel countriesModel = CountriesModel.fromJson(data);
        repoCountriesModel = countriesModel;
        if (validString(countriesModel.showError())) {
          return Left(countriesModel.showError());
        }
      }
      return Right(repoCountriesModel!);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  StatesModel? repoStatesModel;
  int? chosenCountryId;
  Future<Either<String, StatesModel>> getStatesFromDataBase({required int countryId}) async {
    try {
      if (repoStatesModel == null || (chosenCountryId != countryId)) {
        chosenCountryId = countryId;
        var response = await apiHelper.getData(
          EndPoints.states(countryId: countryId),
          lang: langRepo.lang,
          typeJSON: true,
          token: authRepo.token,
        );

        final data = jsonDecode(response);

        StatesModel statesModel = StatesModel.fromJson(data);
        repoStatesModel = statesModel;

        if (validString(statesModel.showError())) {
          return Left(statesModel.showError());
        }
      }
      return Right(repoStatesModel!);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  Future<Either<String, CitiesModel>> getCitiesFromDataBase({required int stateId}) async {
    try {
      var response = await apiHelper.getData(
        EndPoints.cities(stateId: stateId),
        lang: langRepo.lang,
        typeJSON: true,
        token: authRepo.token,
      );

      final data = jsonDecode(response);
      CitiesModel citiesModel = CitiesModel.fromJson(data);
      if (validString(citiesModel.showError())) {
        return Left(citiesModel.showError());
      }

      return Right(citiesModel);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }

  PlaceOfWorkModel? repoPlaceOfWork;
  Future<Either<String, PlaceOfWorkModel>> getPlaceOfWorkFromDataBase() async {
    try {
      if (repoPlaceOfWork == null) {
        final token =
            await cacheHelper.get(kUserKey).then((json) => json == null ? null : UserData.fromJson(json).token);
        var response = await apiHelper.getData(
          EndPoints.placeOfWOrk,
          lang: langRepo.lang,
          typeJSON: true,
          token: token,
        );

        final data = jsonDecode(response);
        PlaceOfWorkModel placeOfWorkModel = PlaceOfWorkModel.fromJson(data);
        repoPlaceOfWork = placeOfWorkModel;
        if (validString(placeOfWorkModel.showError())) {
          return Left(placeOfWorkModel.showError());
        }
      }
      return Right(repoPlaceOfWork!);
    } catch (e, s) {
      log(e.toString());
      log(s.toString());
      return Left(getServerError());
    }
  }
}
