import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/countries_model.dart';

import '../../../models/place_of_work_model.dart';
import '../../models/citiess_model.dart';
import '../../models/states_model.dart';

class FilterState extends Equatable {
  // final GetCountriesState getCountriesState;
  final GetCategoriesState getCategoriesState;
  final GetCountryAndCity getCountryAndCity;

  copyWith({
    // GetCountriesState? getCountriesState,
    GetCategoriesState? getCategoriesState,
    GetCountryAndCity? getCountryAndCity,
  }) {
    return FilterState(
      // getCountriesState: getCountriesState ?? this.getCountriesState,
      getCategoriesState: getCategoriesState ?? this.getCategoriesState,
      getCountryAndCity: getCountryAndCity ?? this.getCountryAndCity,
    );
  }

  const FilterState({
    // this.getCountriesState = const GetCountriesState(),
    this.getCategoriesState = const GetCategoriesState(),
    this.getCountryAndCity = const GetCountryAndCity(),
  });

  @override
  List<Object?> get props => [
        // getCountriesState,
        getCategoriesState,
        getCountryAndCity,
      ];
}

// class GetCountriesState extends Equatable {
//   final bool? success;
//   final LoadingState loadingState;
//   final String? error;
//   final CountriesModel? countriesModel;
//   final List<CountriesData>? countriesDataList;
//
//   const GetCountriesState({
//     this.success,
//     this.loadingState = const LoadingState(),
//     this.error,
//     this.countriesModel,
//     this.countriesDataList,
//   });
//
//   GetCountriesState asLoading() => const GetCountriesState(
//         loadingState: LoadingState.loading(),
//       );
//
//   GetCountriesState asLoadingSuccess(
//       {bool? success,
//       CountriesModel? countriesModel,
//       PlaceOfWorkModel? placeOfWorkModel,
//       List<CountriesData>? countriesDataList}) {
//     return GetCountriesState(
//       success: success,
//       countriesModel: countriesModel,
//       countriesDataList: countriesDataList,
//     );
//   }
//
//   GetCountriesState asLoadingFailed(String error) => GetCountriesState(
//         error: error,
//       );
//
//   GetCountriesState asSearchedFoundStates({
//     List<CountriesData>? searchedList,
//     bool? success,
//     CountriesModel? countriesModel,
//   }) =>
//       GetCountriesState(
//         countriesDataList: searchedList,
//         success: success,
//         countriesModel: countriesModel,
//       );
//
//   GetCountriesState asSearchedEmptyStates({
//     List<CountriesData>? searchedList,
//     bool? success,
//     CountriesModel? countriesModel,
//   }) =>
//       GetCountriesState(
//         countriesDataList: searchedList,
//         countriesModel: countriesModel,
//         success: success,
//       );
//
//   @override
//   List<Object?> get props => [
//         success,
//         loadingState,
//         error,
//         countriesModel,
//         countriesDataList,
//       ];
// }

class GetCategoriesState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final PlaceOfWorkModel? placeOfWorkModel;
  final CountriesModel? countriesModel;
  final List<CountriesData>? searchedCountriesList;
  final List<PlaceOfWorkData>? searchedPlaceOfWorkList;

  const GetCategoriesState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.placeOfWorkModel,
    this.countriesModel,
    this.searchedCountriesList,
    this.searchedPlaceOfWorkList,
  });

  GetCategoriesState asLoading() => const GetCategoriesState(
        loadingState: LoadingState.loading(),
      );

  GetCategoriesState asStatesLoading() => const GetCategoriesState(
        loadingState: LoadingState.loading(),
      );

  GetCategoriesState asLoadingSuccess(
          {required bool success,
          PlaceOfWorkModel? placeOfWorkModel,
          CountriesModel? countriesModel,
          List<PlaceOfWorkData>? searchedPlaceOfWorkList}) =>
      GetCategoriesState(
        success: success,
        placeOfWorkModel: placeOfWorkModel,
        countriesModel: countriesModel,
        searchedPlaceOfWorkList: searchedPlaceOfWorkList,
      );

  GetCategoriesState asLoadingFailed(String error) => GetCategoriesState(
        error: error,
      );

  GetCategoriesState asSearchSuccess({
    bool? success,
    required PlaceOfWorkModel placeOfWorkModel,
    List<PlaceOfWorkData>? searchedPlaceOfWorkList,
  }) =>
      GetCategoriesState(
        success: success,
        placeOfWorkModel: placeOfWorkModel,
        searchedPlaceOfWorkList: searchedPlaceOfWorkList,
      );

  GetCategoriesState asSearchResultEmpty({
    bool? success,
    required PlaceOfWorkModel placeOfWorkModel,
    List<PlaceOfWorkData>? searchedCategoriesList,
  }) =>
      GetCategoriesState(
        success: success,
        placeOfWorkModel: placeOfWorkModel,
        searchedPlaceOfWorkList: searchedCategoriesList,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        placeOfWorkModel,
        countriesModel,
      ];
}

class GetCountryAndCity extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final CountriesModel? countriesModel;
  final CitiesModel? citiesModel;
  final StatesModel? statesModel;
  final List<StatesData>? statesList;
  final List<CountriesData>? countriesList;

  const GetCountryAndCity(
      {this.success,
      this.loadingState = const LoadingState(),
      this.error,
      this.citiesModel,
      this.statesModel,
      this.countriesModel,
      this.statesList,
      this.countriesList});

  GetCountryAndCity asLoading() => const GetCountryAndCity(
        loadingState: LoadingState.loading(),
      );

  GetCountryAndCity asStatesLoading(CountriesModel? countriesModel, List<CountriesData>? countriesList) =>
      GetCountryAndCity(
          loadingState: const LoadingState.reloading(), countriesModel: countriesModel, countriesList: countriesList);

  GetCountryAndCity asLoadingSuccess({
    required bool success,
    CountriesModel? countriesModel,
    CitiesModel? citiesModel,
    StatesModel? statesModel,
    List<StatesData>? statesList,
    List<CountriesData>? countriesList,
  }) =>
      GetCountryAndCity(
          success: success,
          citiesModel: citiesModel,
          countriesModel: countriesModel,
          statesModel: statesModel,
          statesList: statesList,
          countriesList: countriesList);

  GetCountryAndCity asLoadingFailed(String error) => GetCountryAndCity(
        error: error,
      );

  GetCountryAndCity asSearchedFoundStates({
    List<StatesData>? stateList,
    List<CountriesData>? countriesList,
    CountriesModel? countriesModel,
    bool? success,
    StatesModel? statesModel,
  }) =>
      GetCountryAndCity(
          statesList: stateList,
          success: success,
          countriesModel: countriesModel,
          statesModel: statesModel,
          countriesList: countriesList);

  GetCountryAndCity asSearchedEmptyStates({
    List<StatesData>? stateList,
    List<CountriesData>? countriesList,
    bool? success,
    CountriesModel? countriesModel,
    StatesModel? statesModel,
  }) =>
      GetCountryAndCity(
        statesList: stateList,
        countriesModel: countriesModel,
        success: success,
        statesModel: statesModel,
        countriesList: countriesList,
      );

  @override
  List<Object?> get props =>
      [success, loadingState, error, countriesModel, citiesModel, statesModel, statesList, countriesList];
}
