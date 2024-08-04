import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/models/place_of_work_model.dart';
import 'package:mostaql/repos/home_repo.dart';

import '../../../models/countries_model.dart';
import '../../models/states_model.dart';
import 'filter_state.dart';

class FilterBloc extends Cubit<FilterState> {
  FilterBloc({required this.homeRepo}) : super(const FilterState());
  final HomeRepo homeRepo;

  getCountries() async {
    emit(
      state.copyWith(
        getCountryAndCity: state.getCountryAndCity.asLoading(),
      ),
    );
    final f = await homeRepo.geCountries();
    f.fold(
      (l) => emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            getCountryAndCity: state.getCountryAndCity
                .asLoadingSuccess(success: true, countriesModel: r, countriesList: r.countriesData),
          ),
        );
      },
    );
  }

  getCategories() async {
    emit(
      state.copyWith(
        getCategoriesState: state.getCategoriesState.asLoading(),
      ),
    );
    final f = await homeRepo.getPlaceOfWorkFromDataBase();
    f.fold(
      (l) => emit(
        state.copyWith(
          getCategoriesState: state.getCategoriesState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            getCategoriesState: state.getCategoriesState.asLoadingSuccess(
              success: true,
              placeOfWorkModel: r,
              countriesModel: state.getCountryAndCity.countriesModel,
              searchedPlaceOfWorkList: r.placeOfWorkDataList,
            ),
          ),
        );
      },
    );
  }

  searchInCategories({
    required String searchWord,
    required PlaceOfWorkModel placeOfWorkModel,
  }) {
    List<PlaceOfWorkData> searchCategoriesList = [];
    emit(
      state.copyWith(
        getCategoriesState: state.getCategoriesState.asLoading(),
      ),
    );
    searchCategoriesList.clear();
    for (var element in placeOfWorkModel.placeOfWorkDataList) {
      if (element.title.toLowerCase().contains(searchWord.toLowerCase())) {
        searchCategoriesList.add(element);
      }
    }
    if (searchCategoriesList.isNotEmpty) {
      emit(
        state.copyWith(
          getCategoriesState: state.getCategoriesState.asSearchSuccess(
            placeOfWorkModel: placeOfWorkModel,
            searchedPlaceOfWorkList: searchCategoriesList,
            success: true,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          getCategoriesState: state.getCategoriesState.asSearchResultEmpty(
            success: true,
            placeOfWorkModel: placeOfWorkModel,
            searchedCategoriesList: searchCategoriesList,
          ),
        ),
      );
    }
  }

  searchInCountries({
    required String searchWord,
    required CountriesModel countriesModel,
  }) {
    List<CountriesData> searchCountriesList = [];
    emit(
      state.copyWith(
        getCountryAndCity: state.getCountryAndCity.asLoading(),
      ),
    );
    searchCountriesList.clear();
    for (var element in countriesModel.countriesData) {
      if (element.name.toLowerCase().contains(searchWord.toLowerCase())) {
        searchCountriesList.add(element);
      }
    }
    if (searchCountriesList.isNotEmpty) {
      debugPrint('contactList is not  Empty');
      emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asSearchedFoundStates(
            success: true,
            countriesModel: countriesModel,
            countriesList: searchCountriesList,
          ),
        ),
      );
    } else {
      debugPrint('contactList is Empty');
      emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asSearchedEmptyStates(
            success: true,
            countriesModel: countriesModel,
            countriesList: searchCountriesList,
          ),
        ),
      );
    }

    return searchCountriesList;
  }

  getStates(CountriesModel countriesModel, {required int countryId}) async {
    emit(
      state.copyWith(
        getCountryAndCity: state.getCountryAndCity.asStatesLoading(
          countriesModel,
          countriesModel.countriesData,
        ),
      ),
    );
    final f = await homeRepo.getStatesFromDataBase(countryId: countryId);
    f.fold(
      (l) => emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) => emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asLoadingSuccess(
            success: true,
            statesModel: r,
            countriesModel: countriesModel,
            statesList: r.statesData,
            countriesList: countriesModel.countriesData,
          ),
        ),
      ),
    );
  }

  getCities(StatesModel statesModel, {required int countryId}) async {
    emit(state.copyWith(getCountryAndCity: state.getCountryAndCity.asLoading()));
    final f = await homeRepo.getCitiesFromDataBase(stateId: countryId);
    f.fold(
      (l) => emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asLoadingFailed(l.toString()),
        ),
      ),
      (r) => emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asLoadingSuccess(
            success: true,
            citiesModel: r,
            statesModel: statesModel,
          ),
        ),
      ),
    );
  }

  searchInStates({
    required StatesModel statesModel,
    required String searchWord,
    required CountriesModel countriesModel,
  }) {
    List<StatesData> searchStatesList = [];
    emit(
      state.copyWith(
        getCountryAndCity: state.getCountryAndCity.asLoading(),
      ),
    );
    searchStatesList.clear();
    for (var element in statesModel.statesData) {
      if (element.name.toLowerCase().contains(searchWord.toLowerCase())) {
        searchStatesList.add(element);
      }
    }
    if (searchStatesList.isNotEmpty) {
      emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asSearchedFoundStates(
            success: true,
            statesModel: statesModel,
            countriesModel: countriesModel,
            stateList: searchStatesList,
          ),
        ),
      );
    } else {
      emit(
        state.copyWith(
          getCountryAndCity: state.getCountryAndCity.asSearchedEmptyStates(
            success: true,
            statesModel: statesModel,
            countriesModel: countriesModel,
            stateList: searchStatesList,
          ),
        ),
      );
    }

    return searchStatesList;
  }
}
