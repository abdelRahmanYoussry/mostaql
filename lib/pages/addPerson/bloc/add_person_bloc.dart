import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/parameters/contact_paramaters.dart';
import 'package:mostaql/repos/add_person_repo.dart';

import '../../../repos/contract_repo.dart';
import 'add_person_state.dart';

class AddPersonBloc extends Cubit<AddPersonState> {
  AddPersonBloc({required this.addPersonRepo, required this.contractRepo}) : super(const AddPersonState());

  List<String> tagsList = [];
  final AddPersonRepo addPersonRepo;
  final ContractRepo contractRepo;
  addTagsToPerson({required String word}) {
    emit(
      state.copyWith(
        tagsState: state.tagsState.asLoading(),
      ),
    );

    tagsList.add(word);
    emit(
      state.copyWith(
        tagsState: state.tagsState.asLoadingSuccess(true),
      ),
    );
  }

  removeTagsFromPerson({required int index}) {
    emit(state.copyWith(tagsState: state.tagsState.asLoading()));
    tagsList.removeAt(index);
    emit(state.copyWith(tagsState: state.tagsState.asLoadingSuccess(true)));
  }

  getTags() {
    List listOfTagsOnly = tagsList.map((e) => e.trim()).toList();
    return listOfTagsOnly.join(",");
  }

  addPersonToDataBase({required ContactParameters addPersonParameters}) async {
    emit(
      state.copyWith(
        submitAddPersonState: state.submitAddPersonState.asLoading(),
      ),
    );
    final f = await contractRepo.addPersonToDataBase(addPersonParameters: addPersonParameters);
    f.fold(
      (l) => emit(
        state.copyWith(
          submitAddPersonState: state.submitAddPersonState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            submitAddPersonState: state.submitAddPersonState.asLoadingSuccess(
              globalResponseModel: r,
              success: true,
            ),
          ),
        );
      },
    );
  }
}
