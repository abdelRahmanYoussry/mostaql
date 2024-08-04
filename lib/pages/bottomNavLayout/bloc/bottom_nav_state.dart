import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/models/contract_model.dart';

class BottomNavState extends Equatable {
  final GetUncompletedContractsState uncompletedContractsState;
  final SubmitUserContactsState userContactsState;

  copyWith({
    GetUncompletedContractsState? getUncompletedContractsState,
    SubmitUserContactsState? userContactsState,
  }) {
    return BottomNavState(
      uncompletedContractsState: getUncompletedContractsState ?? this.uncompletedContractsState,
      userContactsState: userContactsState ?? this.userContactsState,
    );
  }

  const BottomNavState({
    this.uncompletedContractsState = const GetUncompletedContractsState(),
    this.userContactsState = const SubmitUserContactsState(),
  });

  @override
  List<Object?> get props => [uncompletedContractsState, userContactsState];
}

class GetUncompletedContractsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final ContactModel? contactModel;
  final List<ContactData>? unCompletedContactsDataList;

  const GetUncompletedContractsState(
      {this.success,
      this.loadingState = const LoadingState(),
      this.error,
      this.contactModel,
      this.unCompletedContactsDataList});

  GetUncompletedContractsState asLoading() => const GetUncompletedContractsState(
        loadingState: LoadingState.loading(),
      );

  GetUncompletedContractsState asLoadingSuccess(
          {bool? success, ContactModel? contactModel, List<ContactData>? unCompletedContactsDataList}) =>
      GetUncompletedContractsState(
        success: success,
        contactModel: contactModel,
        unCompletedContactsDataList: unCompletedContactsDataList,
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
        unCompletedContactsDataList,
      ];
}

class SubmitUserContactsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<Contact>? contactsList;

  const SubmitUserContactsState(
      {this.success, this.loadingState = const LoadingState(), this.error, this.contactsList});

  SubmitUserContactsState asLoading() => const SubmitUserContactsState(
        loadingState: LoadingState.loading(),
      );
  SubmitUserContactsState asLoadingSuccess({bool? success, required List<Contact> contactsList}) =>
      SubmitUserContactsState(success: success, contactsList: contactsList);

  SubmitUserContactsState asSearchSuccess({bool? success, required List<Contact> contactsList}) =>
      SubmitUserContactsState(success: success, contactsList: contactsList);

  SubmitUserContactsState asSearchResultEmpty({bool? success, required List<Contact> contactsList}) =>
      SubmitUserContactsState(success: success, contactsList: contactsList);

  SubmitUserContactsState asLoadingFailed({
    bool? success,
  }) =>
      SubmitUserContactsState(success: success);

  @override
  List<Object?> get props => [success, loadingState, error, contactsList];
}
