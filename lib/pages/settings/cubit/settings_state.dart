import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:mostaql/models/about_app_model.dart';
import 'package:mostaql/models/recently_profile_photos_model.dart';
import 'package:mostaql/models/user_model.dart';

import '../../../core/utils/loading_state.dart';
import '../../../models/contract_model.dart';
import '../../../models/friend_connection_response.dart';

class SettingsPageState extends Equatable {
  final GetUserProfileState userProfileState;
  final SettingGetUserFriendsState getUserFriendsState;
  final ChangeLangState changeLangState;
  final PickUpImageState pickUpImageState;
  final GetAboutAppData getAboutAppData;
  final GetDBUserContactsState getDBUserContactsState;

  const SettingsPageState({
    this.userProfileState = const GetUserProfileState(),
    this.getUserFriendsState = const SettingGetUserFriendsState(),
    this.changeLangState = const ChangeLangState(),
    this.pickUpImageState = const PickUpImageState(),
    this.getAboutAppData = const GetAboutAppData(),
    this.getDBUserContactsState = const GetDBUserContactsState(),
  });

  copyWith({
    GetUserProfileState? userProfileState,
    SettingGetUserFriendsState? getUserFriendsState,
    ChangeLangState? changeLangState,
    PickUpImageState? pickUpImageState,
    GetUserContractsState? getUserContractsState,
    GetAboutAppData? getAboutAppData,
    GetDBUserContactsState? getDBUserContactsState,
  }) {
    return SettingsPageState(
      userProfileState: userProfileState ?? this.userProfileState,
      getUserFriendsState: getUserFriendsState ?? this.getUserFriendsState,
      changeLangState: changeLangState ?? this.changeLangState,
      pickUpImageState: pickUpImageState ?? this.pickUpImageState,
      getAboutAppData: getAboutAppData ?? this.getAboutAppData,
      getDBUserContactsState: getDBUserContactsState ?? this.getDBUserContactsState,
    );
  }

  @override
  List<Object?> get props => [
        userProfileState,
        getUserFriendsState,
        changeLangState,
        pickUpImageState,
        getAboutAppData,
        getDBUserContactsState,
      ];
}

class GetUserProfileState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final UserData? userData;
  final String? pickedImagePath;
  final File? pickedImageFile;
  final RecentlyPhotoData? recentlyPhotoData;

  const GetUserProfileState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.userData,
    this.pickedImagePath,
    this.pickedImageFile,
    this.recentlyPhotoData,
  });

  GetUserProfileState asLoading() => const GetUserProfileState(
        loadingState: LoadingState.loading(),
      );

  GetUserProfileState asLoadingSuccess(
          {bool? success,
          UserData? userData,
          String? pickedImagePath,
          File? pickedImageFile,
          RecentlyPhotoData? recentlyPhotoData}) =>
      GetUserProfileState(
        success: success,
        userData: userData,
        pickedImagePath: pickedImagePath,
        pickedImageFile: pickedImageFile,
        recentlyPhotoData: recentlyPhotoData,
      );

  GetUserProfileState asLoadingFailed(String error) => GetUserProfileState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, userData];
}

class SettingGetUserFriendsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<FriendConnectionModel>? friendConnections;

  const SettingGetUserFriendsState(
      {this.success, this.loadingState = const LoadingState(), this.error, this.friendConnections});

  SettingGetUserFriendsState asLoading() => const SettingGetUserFriendsState(
        loadingState: LoadingState.loading(),
      );

  SettingGetUserFriendsState asLoadingSuccess({bool? success, List<FriendConnectionModel>? friendConnections}) =>
      SettingGetUserFriendsState(success: success, friendConnections: friendConnections);

  SettingGetUserFriendsState asLoadingFailed(String error) => SettingGetUserFriendsState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, friendConnections];
}

class ChangeLangState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final String? lang;

  const ChangeLangState({this.success, this.loadingState = const LoadingState(), this.error, this.lang});

  ChangeLangState asLoading() => const ChangeLangState(
        loadingState: LoadingState.loading(),
      );

  ChangeLangState asLoadingSuccess({bool? success, String? lang}) => ChangeLangState(success: success, lang: lang);

  ChangeLangState asLoadingFailed(String error) => ChangeLangState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, lang];
}

class PickUpImageState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final File? image;
  final List<RecentlyPhotoData>? recentlyPhotoData;

  const PickUpImageState(
      {this.success, this.loadingState = const LoadingState(), this.error, this.image, this.recentlyPhotoData});

  PickUpImageState asLoading() => const PickUpImageState(
        loadingState: LoadingState.loading(),
      );

  PickUpImageState asLoadingSuccess({bool? success, File? image, List<RecentlyPhotoData>? recentlyPhotoData}) =>
      PickUpImageState(
        success: success,
        image: image,
        recentlyPhotoData: recentlyPhotoData,
      );

  PickUpImageState asLoadingFailed(String error) => PickUpImageState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, image, recentlyPhotoData];
}

class GetUserContractsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<Contact>? contactList;
  final ContactModel? contactModel;

  const GetUserContractsState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.contactList,
    this.contactModel,
  });

  GetUserContractsState asLoading() => const GetUserContractsState(
        loadingState: LoadingState.loading(),
      );

  GetUserContractsState asLoadingSuccess({bool? success, List<Contact>? contactList, ContactModel? contactModel}) =>
      GetUserContractsState(success: success, contactList: contactList, contactModel: contactModel);

  GetUserContractsState asLoadingFailed({
    required String error,
    required bool success,
  }) =>
      GetUserContractsState(
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [success, loadingState, error, contactList, contactModel];
}

class GetAboutAppData extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final AboutAppData? aboutAppData;

  const GetAboutAppData({this.success, this.loadingState = const LoadingState(), this.error, this.aboutAppData});

  GetAboutAppData asLoading() => const GetAboutAppData(
        loadingState: LoadingState.loading(),
      );

  GetAboutAppData asLoadingSuccess({bool? success, AboutAppData? aboutAppData}) => GetAboutAppData(
        success: success,
        aboutAppData: aboutAppData,
      );

  GetAboutAppData asLoadingFailed({
    required String error,
    required bool success,
  }) =>
      GetAboutAppData(
        error: error,
        success: success,
      );

  @override
  List<Object?> get props => [success, loadingState, error, aboutAppData];
}

class GetDBUserContactsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<ContactData>? contactsList;
  final ContactModel? contractModel;
  final bool? clearSearch;

  const GetDBUserContactsState({
    this.success,
    this.loadingState = const LoadingState(),
    this.error,
    this.contactsList,
    this.contractModel,
    this.clearSearch,
  });

  GetDBUserContactsState asLoading() => const GetDBUserContactsState(
        loadingState: LoadingState.loading(),
      );

  GetDBUserContactsState asPaginationLoading({
    required List<ContactData> contactsList,
  }) =>
      GetDBUserContactsState(
        loadingState: const LoadingState.reloading(),
        contactsList: contactsList,
      );

  GetDBUserContactsState asLoadingSuccess({
    bool? success,
    ContactModel? contractModel,
    required List<ContactData> contactsList,
  }) =>
      GetDBUserContactsState(
        success: success,
        contractModel: contractModel,
        contactsList: contactsList,
      );

  GetDBUserContactsState asSearchResultEmpty({
    bool? success,
    bool? clearSearch,
  }) =>
      GetDBUserContactsState(success: success, clearSearch: clearSearch);

  GetDBUserContactsState asLoadingFailed(String error) => GetDBUserContactsState(
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
