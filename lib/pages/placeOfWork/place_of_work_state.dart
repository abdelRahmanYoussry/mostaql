import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/citiess_model.dart';
import 'package:mostaql/models/countries_model.dart';
import 'package:mostaql/models/place_of_work_model.dart';
import 'package:mostaql/models/states_model.dart';

class PlaceOfWorkState extends Equatable {
  final GetPlaceOfBirthState getPlaceOfBirthState;
  final GetPlaceOfWorkState getPlaceOfWorkState;

  copyWith({
    GetPlaceOfBirthState? submitPlaceOfBirthState,
    GetPlaceOfWorkState? submitPlaceOfWorkState,
  }) {
    return PlaceOfWorkState(
      getPlaceOfBirthState: submitPlaceOfBirthState ?? getPlaceOfBirthState,
      getPlaceOfWorkState: submitPlaceOfWorkState ?? getPlaceOfWorkState,
    );
  }

  const PlaceOfWorkState({
    this.getPlaceOfBirthState = const GetPlaceOfBirthState(),
    this.getPlaceOfWorkState = const GetPlaceOfWorkState(),
  });

  @override
  List<Object?> get props => [
        getPlaceOfBirthState,
        getPlaceOfWorkState,
      ];
}

class GetPlaceOfWorkState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final PlaceOfWorkModel? placeOfWorkModel;
  final List<PlaceOfWorkData>? searchedPlaceList;

  const GetPlaceOfWorkState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.placeOfWorkModel,
    this.searchedPlaceList,
  });

  GetPlaceOfWorkState asLoading() => const GetPlaceOfWorkState(
        loadingState: LoadingState.loading(),
      );

  GetPlaceOfWorkState asLoadingSuccess({
    bool? success,
    PlaceOfWorkModel? placeOfWorkModel,
    List<PlaceOfWorkData>? searchedPlaceList,
  }) =>
      GetPlaceOfWorkState(
        success: success,
        placeOfWorkModel: placeOfWorkModel,
        searchedPlaceList: searchedPlaceList,
      );

  GetPlaceOfWorkState asLoadingFailed(String error) => GetPlaceOfWorkState(
        error: error,
      );

  GetPlaceOfWorkState asSearchedFoundStates(
          {List<PlaceOfWorkData>? searchedList, bool? success, PlaceOfWorkModel? placeOfWorkModel}) =>
      GetPlaceOfWorkState(
        searchedPlaceList: searchedList,
        success: success,
        placeOfWorkModel: placeOfWorkModel,
      );

  GetPlaceOfWorkState asSearchedEmptyStates({
    List<PlaceOfWorkData>? searchedList,
    bool? success,
    PlaceOfWorkModel? placeOfWorkModel,
  }) =>
      GetPlaceOfWorkState(
        searchedPlaceList: searchedList,
        placeOfWorkModel: placeOfWorkModel,
        success: success,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        searchedPlaceList,
      ];
}

class GetPlaceOfBirthState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final CountriesModel? countriesModel;
  final CitiesModel? citiesModel;
  final StatesModel? statesModel;
  final List<StatesData>? searchedStatesData;

  const GetPlaceOfBirthState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.citiesModel,
    this.statesModel,
    this.countriesModel,
    this.searchedStatesData,
  });

  GetPlaceOfBirthState asLoading() => const GetPlaceOfBirthState(
        loadingState: LoadingState.loading(),
      );

  GetPlaceOfBirthState asStatesLoading(
    CountriesModel? countriesModel,
    // List<ExpansionTileController>? expansionTileControllerList,
  ) =>
      GetPlaceOfBirthState(
        loadingState: const LoadingState.reloading(),
        countriesModel: countriesModel,
      );

  GetPlaceOfBirthState asLoadingSuccess({
    required bool success,
    CountriesModel? countriesModel,
    CitiesModel? citiesModel,
    StatesModel? statesModel,
    List<StatesData>? searchedList,
  }) =>
      GetPlaceOfBirthState(
        success: success,
        citiesModel: citiesModel,
        countriesModel: countriesModel,
        statesModel: statesModel,
        searchedStatesData: searchedList,
      );

  GetPlaceOfBirthState asLoadingFailed(String error) => GetPlaceOfBirthState(
        error: error,
      );

  GetPlaceOfBirthState asSearchedFoundStates({
    List<StatesData>? searchedList,
    CountriesModel? countriesModel,
    bool? success,
    StatesModel? statesModel,
  }) =>
      GetPlaceOfBirthState(
        searchedStatesData: searchedList,
        success: success,
        countriesModel: countriesModel,
        statesModel: statesModel,
      );

  GetPlaceOfBirthState asSearchedEmptyStates({
    List<StatesData>? searchedList,
    bool? success,
    CountriesModel? countriesModel,
    StatesModel? statesModel,
  }) =>
      GetPlaceOfBirthState(
        searchedStatesData: searchedList,
        countriesModel: countriesModel,
        success: success,
        statesModel: statesModel,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        countriesModel,
        citiesModel,
        statesModel,
        searchedStatesData,
      ];
}
