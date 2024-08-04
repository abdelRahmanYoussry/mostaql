import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/global_response_model.dart';

import '../../../models/contract_model.dart';

class UpdateContactState extends Equatable {
  final GetTagsState tagsState;
  final UpdatePersonState updatePersonState;
  final GetUncompletedContractsState getUncompletedContractsState;
  final DeletePersonState deletePersonState;
  final GetUsersContactsFromDataBase getUserContactsFromDataBase;

  copyWith({
    GetTagsState? tagsState,
    UpdatePersonState? updatePersonState,
    GetUncompletedContractsState? getUncompletedContractsState,
    DeletePersonState? deletePersonState,
    GetUsersContactsFromDataBase? getUserContactsFromDataBase,
  }) {
    return UpdateContactState(
      tagsState: tagsState ?? this.tagsState,
      updatePersonState: updatePersonState ?? this.updatePersonState,
      getUncompletedContractsState: getUncompletedContractsState ?? this.getUncompletedContractsState,
      getUserContactsFromDataBase: getUserContactsFromDataBase ?? this.getUserContactsFromDataBase,
      deletePersonState: deletePersonState ?? this.deletePersonState,
      // submitDeleteContacts: submitDeleteContacts ?? this.submitDeleteContacts,
    );
  }

  const UpdateContactState({
    this.tagsState = const GetTagsState(),
    this.updatePersonState = const UpdatePersonState(),
    this.getUncompletedContractsState = const GetUncompletedContractsState(),
    this.deletePersonState = const DeletePersonState(),
    this.getUserContactsFromDataBase = const GetUsersContactsFromDataBase(),
  });

  @override
  List<Object?> get props => [
        tagsState,
        updatePersonState,
        getUncompletedContractsState,
        deletePersonState,
        getUserContactsFromDataBase,
      ];
}

class GetTagsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;

  const GetTagsState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
  });

  GetTagsState asLoading() => const GetTagsState(
        loadingState: LoadingState.loading(),
      );

  GetTagsState asLoadingSuccess(bool success) => GetTagsState(
        success: success,
      );

  GetTagsState asLoadingFailed(String error) => GetTagsState(
        error: error,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
      ];
}

class UpdatePersonState extends Equatable {
  final bool? success;
  final bool? isSaveJustCurrent;
  final LoadingState loadingState;
  final String? error;
  final GlobalResponseModel? globalResponseModel;

  const UpdatePersonState({
    this.success,
    this.isSaveJustCurrent,
    this.loadingState = const LoadingState(),
    this.error,
    this.globalResponseModel,
  });

  UpdatePersonState asLoading() => const UpdatePersonState(
        loadingState: LoadingState.loading(),
      );

  UpdatePersonState asLoadingInJustSave() => const UpdatePersonState(
        loadingState: LoadingState.reloading(),
      );

  UpdatePersonState asLoadingSuccess(
          {required bool success, required GlobalResponseModel globalResponseModel, required bool isSaveJustCurrent}) =>
      UpdatePersonState(
          success: success, globalResponseModel: globalResponseModel, isSaveJustCurrent: isSaveJustCurrent);

  UpdatePersonState asLoadingFailed(String error) => UpdatePersonState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, globalResponseModel];
}

class DeletePersonState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final GlobalResponseModel? globalResponseModel;

  const DeletePersonState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.globalResponseModel,
  });

  DeletePersonState asLoading() => const DeletePersonState(
        loadingState: LoadingState.loading(),
      );

  DeletePersonState asLoadingSuccess({required bool success, required GlobalResponseModel globalResponseModel}) =>
      DeletePersonState(
        success: success,
        globalResponseModel: globalResponseModel,
      );

  DeletePersonState asLoadingFailed(String error) => DeletePersonState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, globalResponseModel];
}

class GetUncompletedContractsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final ContactModel? contactModel;
  final List<ContactData>? contactsDataList;

  const GetUncompletedContractsState(
      {this.success, this.loadingState = const LoadingState(), this.error, this.contactModel, this.contactsDataList});

  GetUncompletedContractsState asLoading() => const GetUncompletedContractsState(
        loadingState: LoadingState.loading(),
      );

  GetUncompletedContractsState asLoadingSuccess(
          {bool? success, ContactModel? contactModel, List<ContactData>? contactsDataList}) =>
      GetUncompletedContractsState(
        success: success,
        contactModel: contactModel,
        contactsDataList: contactsDataList,
      );

  GetUncompletedContractsState asLoadingFailed(String error) => GetUncompletedContractsState(
        error: error,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        contactModel,
        contactsDataList,
      ];
}

class GetUsersContactsFromDataBase extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<ContactData>? contactsList;
  final ContactModel? contractModel;
  final bool? clearSearch;

  const GetUsersContactsFromDataBase({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.contactsList,
    this.contractModel,
    this.clearSearch,
  });

  GetUsersContactsFromDataBase asLoading() => const GetUsersContactsFromDataBase(
        loadingState: LoadingState.loading(),
      );

  GetUsersContactsFromDataBase asPaginationLoading({
    required List<ContactData> contactsList,
  }) =>
      GetUsersContactsFromDataBase(
        loadingState: const LoadingState.reloading(),
        contactsList: contactsList,
      );

  GetUsersContactsFromDataBase asLoadingSuccess({
    bool? success,
    ContactModel? contractModel,
    required List<ContactData> contactsList,
  }) =>
      GetUsersContactsFromDataBase(
        success: success,
        contractModel: contractModel,
        contactsList: contactsList,
      );

  GetUsersContactsFromDataBase asSearchResultEmpty({
    bool? success,
    bool? clearSearch,
  }) =>
      GetUsersContactsFromDataBase(success: success, clearSearch: clearSearch);

  GetUsersContactsFromDataBase asLoadingFailed(String error) => GetUsersContactsFromDataBase(
        error: error,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        contactsList,
        contractModel,
      ];
}

class SubmitDeleteContacts extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<ContactData>? deletedContactsList;
  final GlobalResponseModel? globalResponseModel;

  const SubmitDeleteContacts({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.deletedContactsList,
    this.globalResponseModel,
  });

  SubmitDeleteContacts asLoading() => const SubmitDeleteContacts(
        loadingState: LoadingState.loading(),
      );

  SubmitDeleteContacts asLoadingSuccess(
          {bool? success,
          List<ContactData>? deletedContactsList,
          GlobalResponseModel? globalResponseModel,
          String? error}) =>
      SubmitDeleteContacts(
        deletedContactsList: deletedContactsList,
        error: error,
        globalResponseModel: globalResponseModel,
      );

  SubmitDeleteContacts asLoadingFailed({
    required String error,
    required bool success,
  }) =>
      SubmitDeleteContacts(
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [success, loadingState, error, deletedContactsList];
}
