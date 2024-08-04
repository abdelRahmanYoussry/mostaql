import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/models/countries_model.dart';
import 'package:mostaql/models/states_model.dart';
import 'package:mostaql/pages/placeOfBirth/place_of_birth_state.dart';
import 'package:mostaql/repos/add_person_repo.dart';

class PlaceOfBirthBloc extends Cubit<PlaceOfBirthState> {
  PlaceOfBirthBloc({required this.addPersonRepo}) : super(const PlaceOfBirthState());

  final AddPersonRepo addPersonRepo;

  getCountries() async {
    emit(
      state.copyWith(
        submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoading(),
      ),
    );
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
              success: true, statesModel: r, countriesModel: countriesModel, searchedList: r.statesData),
        ),
      ),
    );
  }

  getCities(StatesModel statesModel, {required int countryId}) async {
    emit(state.copyWith(submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoading()));
    final f = await addPersonRepo.getCitiesFromDataBase(stateId: countryId);
    f.fold(
      (l) => emit(state.copyWith(
        submitPlaceOfBirthState: state.getPlaceOfBirthState.asLoadingFailed(l.toString()),
      )),
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
            success: true,
            statesModel: statesModel,
            countriesModel: countriesModel,
            searchedList: searchStatesList,
          ),
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
}
