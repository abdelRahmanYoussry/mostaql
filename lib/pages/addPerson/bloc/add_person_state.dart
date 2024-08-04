import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/citiess_model.dart';
import 'package:mostaql/models/countries_model.dart';
import 'package:mostaql/models/global_response_model.dart';
import 'package:mostaql/models/place_of_work_model.dart';
import 'package:mostaql/models/states_model.dart';

class AddPersonState extends Equatable {
  final SubmitTagsState tagsState;
  final SubmitAddPersonState submitAddPersonState;

  copyWith({
    SubmitTagsState? tagsState,
    SubmitAddPersonState? submitAddPersonState,
    SubmitGetPlaceOfBirthState? submitPlaceOfBirthState,
    SubmitGetPlaceOfWorkState? submitPlaceOfWorkState,
  }) {
    return AddPersonState(
      tagsState: tagsState ?? this.tagsState,
      submitAddPersonState: submitAddPersonState ?? this.submitAddPersonState,
    );
  }

  const AddPersonState({
    this.tagsState = const SubmitTagsState(),
    this.submitAddPersonState = const SubmitAddPersonState(),
  });

  @override
  List<Object?> get props => [
        tagsState,
        submitAddPersonState,
      ];
}

class SubmitTagsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;

  const SubmitTagsState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
  });

  SubmitTagsState asLoading() => const SubmitTagsState(
        loadingState: LoadingState.loading(),
      );

  SubmitTagsState asLoadingSuccess(bool success) => SubmitTagsState(
        success: success,
      );

  SubmitTagsState asLoadingFailed(String error) => SubmitTagsState(
        error: error,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
      ];
}

class SubmitAddPersonState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;

  final GlobalResponseModel? globalResponseModel;

  const SubmitAddPersonState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.globalResponseModel,
  });

  SubmitAddPersonState asLoading() => const SubmitAddPersonState(
        loadingState: LoadingState.loading(),
      );

  SubmitAddPersonState asLoadingSuccess({
    required bool success,
    required GlobalResponseModel globalResponseModel,
  }) {
    return SubmitAddPersonState(
      success: success,
      globalResponseModel: globalResponseModel,
    );
  }

  SubmitAddPersonState asLoadingFailed(String error) => SubmitAddPersonState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, globalResponseModel];
}

class SubmitGetPlaceOfWorkState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final PlaceOfWorkModel? placeOfWorkModel;
  final List<PlaceOfWorkData>? searchedPlaceList;

  const SubmitGetPlaceOfWorkState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.placeOfWorkModel,
    this.searchedPlaceList,
  });

  SubmitGetPlaceOfWorkState asLoading() => const SubmitGetPlaceOfWorkState(
        loadingState: LoadingState.loading(),
      );

  SubmitGetPlaceOfWorkState asLoadingSuccess({
    bool? success,
    PlaceOfWorkModel? placeOfWorkModel,
    List<PlaceOfWorkData>? searchedPlaceList,
  }) =>
      SubmitGetPlaceOfWorkState(
        success: success,
        placeOfWorkModel: placeOfWorkModel,
        searchedPlaceList: searchedPlaceList,
      );

  SubmitGetPlaceOfWorkState asLoadingFailed(String error) => SubmitGetPlaceOfWorkState(
        error: error,
      );

  SubmitGetPlaceOfWorkState asSearchedFoundStates({
    List<PlaceOfWorkData>? searchedList,
    bool? success,
    PlaceOfWorkModel? placeOfWorkModel,
  }) =>
      SubmitGetPlaceOfWorkState(
        searchedPlaceList: searchedList,
        success: success,
        placeOfWorkModel: placeOfWorkModel,
      );

  SubmitGetPlaceOfWorkState asSearchedEmptyStates({
    List<PlaceOfWorkData>? searchedList,
    bool? success,
    PlaceOfWorkModel? placeOfWorkModel,
  }) =>
      SubmitGetPlaceOfWorkState(
        searchedPlaceList: searchedList,
        placeOfWorkModel: placeOfWorkModel,
        success: success,
      );

  @override
  List<Object?> get props => [success, loadingState, error, searchedPlaceList];
}

class SubmitGetPlaceOfBirthState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final CountriesModel? countriesModel;
  final CitiesModel? citiesModel;
  final StatesModel? statesModel;
  final List<StatesData>? searchedStatesData;

  const SubmitGetPlaceOfBirthState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.citiesModel,
    this.statesModel,
    this.countriesModel,
    this.searchedStatesData,
  });

  SubmitGetPlaceOfBirthState asLoading() => const SubmitGetPlaceOfBirthState(
        loadingState: LoadingState.loading(),
      );

  SubmitGetPlaceOfBirthState asStatesLoading(
    CountriesModel? countriesModel,
  ) =>
      SubmitGetPlaceOfBirthState(
        loadingState: const LoadingState.reloading(),
        countriesModel: countriesModel,
      );

  SubmitGetPlaceOfBirthState asLoadingSuccess({
    required bool success,
    CountriesModel? countriesModel,
    CitiesModel? citiesModel,
    StatesModel? statesModel,
    List<StatesData>? searchedList,
  }) =>
      SubmitGetPlaceOfBirthState(
        success: success,
        citiesModel: citiesModel,
        countriesModel: countriesModel,
        statesModel: statesModel,
        searchedStatesData: searchedList,
      );

  SubmitGetPlaceOfBirthState asLoadingFailed(String error) => SubmitGetPlaceOfBirthState(
        error: error,
      );

  SubmitGetPlaceOfBirthState asSearchedFoundStates({
    List<StatesData>? searchedList,
    CountriesModel? countriesModel,
    bool? success,
    StatesModel? statesModel,
  }) =>
      SubmitGetPlaceOfBirthState(
        searchedStatesData: searchedList,
        success: success,
        countriesModel: countriesModel,
        statesModel: statesModel,
      );

  SubmitGetPlaceOfBirthState asSearchedEmptyStates({
    List<StatesData>? searchedList,
    bool? success,
    CountriesModel? countriesModel,
    StatesModel? statesModel,
  }) =>
      SubmitGetPlaceOfBirthState(
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
