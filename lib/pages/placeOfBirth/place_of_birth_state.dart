import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/citiess_model.dart';
import 'package:mostaql/models/countries_model.dart';
import 'package:mostaql/models/states_model.dart';

class PlaceOfBirthState extends Equatable {
  final GetPlaceOfBirthState getPlaceOfBirthState;

  copyWith({
    GetPlaceOfBirthState? submitPlaceOfBirthState,
  }) {
    return PlaceOfBirthState(
      getPlaceOfBirthState: submitPlaceOfBirthState ?? getPlaceOfBirthState,
    );
  }

  const PlaceOfBirthState({
    this.getPlaceOfBirthState = const GetPlaceOfBirthState(),
  });

  @override
  List<Object?> get props => [
        getPlaceOfBirthState,
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
