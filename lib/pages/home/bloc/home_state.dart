import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/contract_model.dart';

import '../../../models/global_response_model.dart';

class HomeState extends Equatable {
  final SearchUserContactsState userContactsState;
  final SearchInDataBaseContactsState searchInDataBaseContactsState;
  final UncompletedContractsState uncompletedContractsState;
  final UploadContractsState uploadContractsState;
  final GetUserContractsState getUserContractsState;
  final DeletePersonState deletePersonState;

  copyWith({
    SearchUserContactsState? userContactsState,
    SearchInDataBaseContactsState? searchInDataBaseContactsState,
    UncompletedContractsState? uncompletedContractsState,
    UploadContractsState? uploadContractsState,
    GetUserContractsState? getUserContractsState,
    DeletePersonState? deletePersonState,
  }) {
    return HomeState(
        userContactsState: userContactsState ?? this.userContactsState,
        searchInDataBaseContactsState: searchInDataBaseContactsState ?? this.searchInDataBaseContactsState,
        uncompletedContractsState: uncompletedContractsState ?? this.uncompletedContractsState,
        uploadContractsState: uploadContractsState ?? this.uploadContractsState,
        getUserContractsState: getUserContractsState ?? this.getUserContractsState,
        deletePersonState: deletePersonState ?? this.deletePersonState);
  }

  const HomeState(
      {this.userContactsState = const SearchUserContactsState(),
      this.searchInDataBaseContactsState = const SearchInDataBaseContactsState(),
      this.uncompletedContractsState = const UncompletedContractsState(),
      this.uploadContractsState = const UploadContractsState(),
      this.getUserContractsState = const GetUserContractsState(),
      this.deletePersonState = const DeletePersonState()});

  @override
  List<Object?> get props => [
        userContactsState,
        searchInDataBaseContactsState,
        uncompletedContractsState,
        uploadContractsState,
        getUserContractsState,
        deletePersonState
      ];
}

class SearchUserContactsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<Contact>? contactsList;

  const SearchUserContactsState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.contactsList,
  });

  SearchUserContactsState asLoading() => const SearchUserContactsState(
        loadingState: LoadingState.loading(),
      );

  SearchUserContactsState asLoadingSuccess({
    bool? success,
    required List<Contact> contactsList,
  }) =>
      SearchUserContactsState(
        success: success,
        contactsList: contactsList,
      );

  SearchUserContactsState asSearchSuccess({
    bool? success,
    required List<Contact> contactsList,
  }) =>
      SearchUserContactsState(
        success: success,
        contactsList: contactsList,
      );

  SearchUserContactsState asSearchResultEmpty({
    bool? success,
    required List<Contact> contactsList,
  }) =>
      SearchUserContactsState(
        success: success,
        contactsList: contactsList,
      );

  SearchUserContactsState asLoadingFailed({
    bool? success,
  }) =>
      SearchUserContactsState(success: success);

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        contactsList,
      ];
}

class SearchInDataBaseContactsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<ContactData>? contactsList;
  final ContactModel? contractModel;
  final bool? clearSearch;

  const SearchInDataBaseContactsState(
      {this.success,
      this.loadingState = const LoadingState(),
      this.error,
      this.contactsList,
      this.contractModel,
      this.clearSearch});

  SearchInDataBaseContactsState asLoading() => const SearchInDataBaseContactsState(
        loadingState: LoadingState.loading(),
      );

  SearchInDataBaseContactsState asPaginationLoading({
    required List<ContactData> contactsList,
  }) =>
      SearchInDataBaseContactsState(
        loadingState: const LoadingState.reloading(),
        contactsList: contactsList,
      );

  SearchInDataBaseContactsState asSearchSuccess({
    bool? success,
    ContactModel? contractModel,
    required List<ContactData> contactsList,
  }) =>
      SearchInDataBaseContactsState(
        success: success,
        contractModel: contractModel,
        contactsList: contactsList,
      );

  SearchInDataBaseContactsState asSearchResultEmpty({
    bool? success,
    bool? clearSearch,
  }) =>
      SearchInDataBaseContactsState(success: success, clearSearch: clearSearch);

  SearchInDataBaseContactsState asLoadingFailed(String error) => SearchInDataBaseContactsState(
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

class UncompletedContractsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final ContactModel? contactModel;
  final List<ContactData>? unCompletedContactsList;

  const UncompletedContractsState(
      {this.success,
      this.loadingState = const LoadingState(),
      this.error,
      this.contactModel,
      this.unCompletedContactsList});

  UncompletedContractsState asLoading() => const UncompletedContractsState(
        loadingState: LoadingState.loading(),
      );

  UncompletedContractsState asLoadingSuccess({
    bool? success,
    ContactModel? contactModel,
    List<ContactData>? unCompletedContactsDataList,
  }) =>
      UncompletedContractsState(
        success: success,
        contactModel: contactModel,
        unCompletedContactsList: unCompletedContactsDataList,
      );

  UncompletedContractsState asLoadingFailed(String error) => UncompletedContractsState(
        error: error,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        contactModel,
        unCompletedContactsList,
      ];
}

class UploadContractsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;

  const UploadContractsState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
  });

  UploadContractsState asLoading() => const UploadContractsState(
        loadingState: LoadingState.loading(),
      );

  UploadContractsState asLoadingSuccess({bool? success}) => UploadContractsState(
        success: success,
      );

  UploadContractsState asLoadingFailed({
    required String error,
    required bool success,
  }) =>
      UploadContractsState(
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
      ];
}

class GetUserContractsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<Contact>? contactList;

  const GetUserContractsState({this.success, this.loadingState = const LoadingState(), this.error, this.contactList});

  GetUserContractsState asLoading() => const GetUserContractsState(
        loadingState: LoadingState.loading(),
      );

  GetUserContractsState asLoadingSuccess({bool? success, List<Contact>? contactList}) =>
      GetUserContractsState(success: success, contactList: contactList);

  GetUserContractsState asLoadingFailed({
    required String error,
    required bool success,
  }) =>
      GetUserContractsState(
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [success, loadingState, error, contactList];
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
