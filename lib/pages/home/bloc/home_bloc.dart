import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/pages/home/bloc/home_state.dart';
import 'package:mostaql/parameters/filter_paramaters.dart';
import 'package:mostaql/repos/contract_repo.dart';
import 'package:mostaql/repos/home_repo.dart';

class HomeBloc extends Cubit<HomeState> {
  HomeBloc({required this.homeRepo, required this.contractRepo}) : super(const HomeState());
  final HomeRepo homeRepo;
  final ContractRepo contractRepo;

  getAllUserContacts({bool? uploadNewContracts}) async {
    emit(
      state.copyWith(
        getUserContractsState: state.getUserContractsState.asLoading(),
      ),
    );
    final f = await contractRepo.getAllUserContact();
    f.fold(
      (l) => {
        emit(
          state.copyWith(
            getUserContractsState: state.getUserContractsState.asLoadingFailed(
              success: false,
              error: l.toString(),
            ),
          ),
        )
      },
      (r) async => {
        emit(
          state.copyWith(
            getUserContractsState: state.getUserContractsState.asLoadingSuccess(
              success: true,
              contactList: r,
            ),
          ),
        ),
        await uploadUserContacts(uploadNewContracts: uploadNewContracts),
      },
    );
  }

  uploadUserContacts({bool? uploadNewContracts}) async {
    emit(
      state.copyWith(
        uploadContractsState: state.uploadContractsState.asLoading(),
      ),
    );

    final data = await contractRepo.uploadContactsToDataBase(uploadNewContracts: uploadNewContracts);

    data.fold(
      (l) {
        emit(
          state.copyWith(
            uploadContractsState: state.uploadContractsState.asLoadingFailed(error: l, success: false),
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            uploadContractsState: state.uploadContractsState.asLoadingSuccess(success: true),
          ),
        );
        await getUncompletedContacts();
      },
    );
  }

  getUncompletedContacts() async {
    emit(
      state.copyWith(
        uncompletedContractsState: state.uncompletedContractsState.asLoading(),
      ),
    );
    final f = await contractRepo.getUnCompletedContacts();
    f.fold(
      (l) => emit(
        state.copyWith(
          uncompletedContractsState: state.uncompletedContractsState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        debugPrint('${r.contractData.length} UnCompleted List Length');
        emit(
          state.copyWith(
            uncompletedContractsState: state.uncompletedContractsState.asLoadingSuccess(
              success: true,
              contactModel: r,
              unCompletedContactsDataList: r.contractData,
            ),
          ),
        );
      },
    );
  }

  searchInUserContacts({required String contactName}) async {
    emit(
      state.copyWith(
        userContactsState: state.userContactsState.asLoading(),
      ),
    );
    final f = await contractRepo.searchInUserContact(contactName: contactName);

    f.fold(
      (l) {
        emit(
          state.copyWith(
            userContactsState: state.userContactsState.asSearchResultEmpty(
              success: false,
              contactsList: contractRepo.searchInUserContactList,
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            userContactsState: state.userContactsState.asSearchSuccess(
              success: true,
              contactsList: contractRepo.searchInUserContactList,
            ),
          ),
        );
      },
    );
  }

  searchInUserContractsDataBase({
    FilterParameters? filterParameters,
    required bool isPagination,
  }) async {
    if (isPagination) {
      emit(
        state.copyWith(
          searchInDataBaseContactsState: state.searchInDataBaseContactsState.asPaginationLoading(
            contactsList: contractRepo.paginationList,
          ),
        ),
      );
    } else {
      contractRepo.paginationList.clear();
      contractRepo.page = 1;
      contractRepo.paginatedContactIds.clear();
      emit(
        state.copyWith(
          searchInDataBaseContactsState: state.searchInDataBaseContactsState.asLoading(),
        ),
      );
    }

    final f = await contractRepo.searchContract(filterParameters: filterParameters);
    f.fold(
      (l) => emit(
        state.copyWith(
          searchInDataBaseContactsState: state.searchInDataBaseContactsState.asLoadingFailed(
            l.toString(),
          ),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            searchInDataBaseContactsState: state.searchInDataBaseContactsState.asSearchSuccess(
              contactsList: r,
            ),
          ),
        );
      },
    );
  }

  emitClearSearch() {
    emit(
      state.copyWith(
        searchInDataBaseContactsState:
            state.searchInDataBaseContactsState.asSearchResultEmpty(success: true, clearSearch: true),
      ),
    );
  }

  deleteContract({required int id}) async {
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
            ), (r) async {
      emit(
        state.copyWith(
          deletePersonState: state.deletePersonState.asLoadingSuccess(
            globalResponseModel: r,
            success: true,
          ),
        ),
      );
      await searchInUserContractsDataBase(
        isPagination: false,
        filterParameters: FilterParameters(),
      );
    });
  }
}
