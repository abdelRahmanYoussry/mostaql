import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/core/utils/notifications/setup_notifications.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/models/user_model.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:mostaql/repos/lang_repo.dart';

import '../app_config.dart';
import '../core/utils/translation_helper.dart';
import '../core/utils/vaildData/valid_data.dart';
import '../models/citiess_model.dart';
import '../models/countries_model.dart';
import '../models/place_of_work_model.dart';
import '../models/states_model.dart';

class HomeRepo {
  final ApiHelper apiHelper;
  final LangRepo langRepo;
  final SetupFCM setupFCM;
  final CacheHelper cacheHelper;
  final AuthRepo authRepo;

  UserData? user;

  HomeRepo(
    this.apiHelper,
    this.langRepo,
    this.setupFCM,
    this.cacheHelper,
    this.authRepo,
  );

  PlaceOfWorkModel? repoPlaceOfWork;
  CountriesModel? repoCountriesModel;
  StatesModel? repoStatesModel;
  int? chosenCountryId;

  Future<Either<String, CountriesModel>> geCountries() async {
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

  Future<Either<String, PlaceOfWorkModel>> getPlaceOfWorkFromDataBase() async {
    try {
      if (repoPlaceOfWork == null) {
        var response = await apiHelper.getData(
          EndPoints.placeOfWOrk,
          lang: langRepo.lang,
          typeJSON: true,
          token: authRepo.token,
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
}
