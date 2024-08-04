import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/pages/updateContact/bloc/update_contact_state.dart';
import 'package:mostaql/parameters/contact_paramaters.dart';
import 'package:mostaql/parameters/filter_paramaters.dart';

import '../../../repos/contract_repo.dart';

class UpdateContactBloc extends Cubit<UpdateContactState> {
  UpdateContactBloc({required this.contractRepo}) : super(const UpdateContactState()) {
    // eventBus.on<FetchUserContracts>().listen((event) {
    //   if (!isClosed) {
    //     getAllUserContactsFromBe(isPagination: false);
    //   }
    // });
  }

  List<String> tagsList = [];
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

  removeTagsFromPerson({int? index, required bool removeAll}) {
    emit(
      state.copyWith(
        tagsState: state.tagsState.asLoading(),
      ),
    );
    if (removeAll) {
      tagsList.clear();
    } else {
      tagsList.removeAt(index!);
    }
    emit(
      state.copyWith(
        tagsState: state.tagsState.asLoadingSuccess(true),
      ),
    );
  }

  getTags() {
    List listOfTagsOnly = tagsList.map((e) => e.trim()).toList();
    return listOfTagsOnly.join(",");
  }

  updateContract({required ContactParameters addPersonParameters, required bool isSaveJustCurrent}) async {
    emit(
      state.copyWith(
        updatePersonState:
            !isSaveJustCurrent ? state.updatePersonState.asLoading() : state.updatePersonState.asLoadingInJustSave(),
      ),
    );
    final f = await contractRepo.updateContact(addPersonParameters: addPersonParameters);
    f.fold(
      (l) => emit(
        state.copyWith(
          updatePersonState: state.updatePersonState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) async {
        emit(
          state.copyWith(
            updatePersonState: state.updatePersonState
                .asLoadingSuccess(globalResponseModel: r, success: true, isSaveJustCurrent: isSaveJustCurrent),
          ),
        );
        if (!isSaveJustCurrent) {
          await getUncompletedContacts();
        }
      },
    );
  }

  deleteContract({required int id, required bool isUnCompleteContact, FilterParameters? filterParameters}) async {
    emit(
      state.copyWith(
        deletePersonState: state.deletePersonState.asLoading(),
      ),
    );
    final f = await contractRepo.deleteContact(id: id);
    f.fold(
      (l) => emit(
        state.copyWith(
          deletePersonState: state.deletePersonState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) async {
        emit(
          state.copyWith(
            deletePersonState: state.deletePersonState.asLoadingSuccess(
              globalResponseModel: r,
              success: true,
            ),
          ),
        );
        if (isUnCompleteContact) {
          await getUncompletedContacts();
        } else {
          eventBus.fire(FetchUserContracts());
          await getAllUserContactsFromBe(isPagination: false, filterParameters: filterParameters);
        }
      },
    );
  }

  getUncompletedContacts() async {
    emit(
      state.copyWith(
        getUncompletedContractsState: state.getUncompletedContractsState.asLoading(),
      ),
    );
    final f = await contractRepo.getUnCompletedContacts();
    f.fold(
      (l) => emit(
        state.copyWith(
          getUncompletedContractsState: state.getUncompletedContractsState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            getUncompletedContractsState: state.getUncompletedContractsState
                .asLoadingSuccess(success: true, contactModel: r, contactsDataList: r.contractData),
          ),
        );
      },
    );
  }

  Future<void> getAllUserContactsFromBe({required bool isPagination, FilterParameters? filterParameters}) async {
    debugPrint("getAllUserContactsFromBe");
    if (isPagination) {
      emit(
        state.copyWith(
          getUserContactsFromDataBase: state.getUserContactsFromDataBase.asPaginationLoading(
            contactsList: contractRepo.paginationList,
          ),
        ),
      );
    } else {
      contractRepo.paginationList.clear();
      contractRepo.page = 1;
      contractRepo.paginatedContactIds.clear();
      // contractRepo.deleteContactsList.clear();
      emit(
        state.copyWith(
          getUserContactsFromDataBase: state.getUserContactsFromDataBase.asLoading(),
        ),
      );
    }

    final f = await contractRepo.getUserContactFromDataBase(filterParameters);
    f.fold(
      (l) => {
        emit(
          state.copyWith(
            getUserContactsFromDataBase: state.getUserContactsFromDataBase.asLoadingFailed(
              l.toString(),
            ),
          ),
        )
      },
      (r) => {
        emit(
          state.copyWith(
            getUserContactsFromDataBase: state.getUserContactsFromDataBase.asLoadingSuccess(
              success: true,
              contactsList: r,
            ),
          ),
        ),
      },
    );
  }

  Future<void> deleteManyContacts({required List<int> contactsList, required FilterParameters filterParameters}) async {
    emit(
      state.copyWith(
        deletePersonState: state.deletePersonState.asLoading(),
      ),
    );
    final f = await contractRepo.deleteMultiContacts(contactsList);
    f.fold(
      (l) => {
        emit(
          state.copyWith(
            deletePersonState: state.deletePersonState.asLoadingFailed(
              l.toString(),
            ),
          ),
        ),
      },
      (r) async {
        emit(
          state.copyWith(
            deletePersonState: state.deletePersonState.asLoadingSuccess(
              globalResponseModel: r,
              success: true,
            ),
          ),
        );
        debugPrint("getAllUserContactsFromBe3333");
        eventBus.fire(FetchUserContracts());
        await getAllUserContactsFromBe(
          isPagination: false,
          filterParameters: filterParameters,
        );
      },
    );
  }

  emitClearSearch() {
    emit(
      state.copyWith(
        getUserContactsFromDataBase:
            state.getUserContactsFromDataBase.asSearchResultEmpty(success: true, clearSearch: true),
      ),
    );
  }
}
