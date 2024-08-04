import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/models/countries_model.dart';
import 'package:mostaql/models/place_of_work_model.dart';
import 'package:mostaql/models/states_model.dart';
import 'package:mostaql/pages/placeOfWork/place_of_work_state.dart';
import 'package:mostaql/repos/add_person_repo.dart';

class PlaceOfWorkBloc extends Cubit<PlaceOfWorkState> {
  PlaceOfWorkBloc({required this.addPersonRepo}) : super(const PlaceOfWorkState());

  final AddPersonRepo addPersonRepo;

  getCountries() async {
    emit(state.copyWith(submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoading()));
    final f = await addPersonRepo.getCountriesFromDataBase();
    f.fold(
      (l) => emit(
        state.copyWith(
          submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingSuccess(
              success: true,
              countriesModel: r,
            ),
          ),
        );
        getStates(r, countryId: r.countriesData.first.id);
      },
    );
  }

  getStates(CountriesModel countriesModel, {required int countryId}) async {
    emit(
      state.copyWith(
        submitPlaceOfBirthState: state.getPlaceOfBirthState.asStatesLoading(
          countriesModel,
        ),
      ),
    );
    final f = await addPersonRepo.getStatesFromDataBase(countryId: countryId);
    f.fold(
      (l) => emit(
        state.copyWith(
          submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) => emit(
        state.copyWith(
          submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingSuccess(
            success: true,
            statesModel: r,
            countriesModel: countriesModel,
            searchedList: r.statesData,
          ),
        ),
      ),
    );
  }

  getCities(StatesModel statesModel, {required int countryId}) async {
    emit(state.copyWith(submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoading()));
    final f = await addPersonRepo.getCitiesFromDataBase(stateId: countryId);
    f.fold(
      (l) => emit(state.copyWith(submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingFailed(l.toString()))),
      (r) => emit(
        state.copyWith(
          submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingSuccess(
            success: true,
            citiesModel: r,
            statesModel: statesModel,
          ),
        ),
      ),
    );
  }

  getPlacesOfWork() async {
    emit(state.copyWith(submitPlaceOfWorkState: state.getPlaceOfWorkState.asLoading()));
    final f = await addPersonRepo.getPlaceOfWorkFromDataBase();
    f.fold(
        (l) => emit(
              state.copyWith(
                submitPlaceOfWorkState: state.getPlaceOfWorkState.asLoadingFailed(
                  l.toString(),
                ),
              ),
            ), (r) {
      emit(
        state.copyWith(
          submitPlaceOfWorkState: state.getPlaceOfWorkState.asLoadingSuccess(
            success: true,
            placeOfWorkModel: r,
            searchedPlaceList: r.placeOfWorkDataList,
          ),
        ),
      );
    });
  }

  searchInStates({
    required StatesModel statesModel,
    required String searchWord,
    required CountriesModel countriesModel,
  }) {
    List<StatesData> searchStatesList = [];
    emit(
      state.copyWith(
        submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoading(),
      ),
    );
    searchStatesList.clear();
    for (var element in statesModel.statesData) {
      if (element.name.toLowerCase().contains(
            searchWord.toLowerCase(),
          )) {
        searchStatesList.add(element);
      }
    }
    if (searchStatesList.isNotEmpty) {
      debugPrint('${searchStatesList.length} not empty22');
      emit(
        state.copyWith(
          submitPlaceOfBirthState: state.getPlaceOfBirthState.asSearchedFoundStates(
              success: true, statesModel: statesModel, countriesModel: countriesModel, searchedList: searchStatesList),
        ),
      );
    } else {
      debugPrint('contactList is Empty');
      emit(
        state.copyWith(
          submitPlaceOfBirthState: state.getPlaceOfBirthState.asSearchedEmptyStates(
              success: true, statesModel: statesModel, countriesModel: countriesModel, searchedList: searchStatesList),
        ),
      );
    }

    return searchStatesList;
  }

  searchInPlaceOfWork({
    required PlaceOfWorkModel placeOfWorkModel,
    required String searchWord,
  }) {
    List<PlaceOfWorkData> searchPlacesList = [];
    emit(
      state.copyWith(
        submitPlaceOfWorkState: state.getPlaceOfWorkState.asLoading(),
      ),
    );
    searchPlacesList.clear();
    for (var element in placeOfWorkModel.placeOfWorkDataList) {
      if (element.title.toLowerCase().contains(
            searchWord.toLowerCase(),
          )) {
        searchPlacesList.add(element);
      }
    }
    if (searchPlacesList.isNotEmpty) {
      debugPrint('${searchPlacesList.length} not empty22');
      emit(
        state.copyWith(
          submitPlaceOfWorkState: state.getPlaceOfWorkState
              .asSearchedFoundStates(success: true, placeOfWorkModel: placeOfWorkModel, searchedList: searchPlacesList),
        ),
      );
    } else {
      debugPrint('contactList is Empty');
      emit(
        state.copyWith(
          submitPlaceOfWorkState: state.getPlaceOfWorkState
              .asSearchedEmptyStates(success: true, placeOfWorkModel: placeOfWorkModel, searchedList: searchPlacesList),
        ),
      );
    }

    return searchPlacesList;
  }
}
