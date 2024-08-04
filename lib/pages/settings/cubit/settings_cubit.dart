import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/pages/settings/cubit/settings_state.dart';
import 'package:mostaql/parameters/filter_paramaters.dart';
import 'package:mostaql/repos/auth_repo.dart';
import 'package:mostaql/repos/contract_repo.dart';
import 'package:mostaql/repos/lang_repo.dart';

import '../../../models/recently_profile_photos_model.dart';
import '../../../repos/connections_repo.dart';

class SettingsPageCubit extends Cubit<SettingsPageState> {
  SettingsPageCubit(this.authRepo, this.connectionsRepo, this.langRepo, this.contractRepo)
      : super(const SettingsPageState()) {
    eventBus.on<FetchSharedContracts>().listen((event) {
      if (!isClosed) {
        getUserFriends(getNewData: false);
      }
    });
    eventBus.on<FetchUserContracts>().listen((event) {
      if (!isClosed) {
        debugPrint("getAllUserContactsFromBe22222");
        getAllUserContactsFromBe(
          isPagination: false,
          filterParameters: FilterParameters(),
        );
      }
    });
  }

  final AuthRepo authRepo;
  final ConnectionsRepo connectionsRepo;
  final LangRepo langRepo;
  final ContractRepo contractRepo;

  Future<void> getProfileData({required bool getNewData}) async {
    if (getNewData) {
      emit(
        state.copyWith(
          userProfileState: state.userProfileState.asLoading(),
        ),
      );
    }
    final r = await authRepo.getProfile(getNewData: getNewData);
    r.fold(
      (l) {
        emit(
          state.copyWith(
            userProfileState: state.userProfileState.asLoadingFailed(
              r.toString(),
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            userProfileState: state.userProfileState.asLoadingSuccess(
              userData: r,
              success: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> getUserFriends({required bool getNewData}) async {
    if (getNewData) {
      emit(
        state.copyWith(
          getUserFriendsState: state.getUserFriendsState.asLoading(),
        ),
      );
    }
    final r = await connectionsRepo.getFriendConnections(
      getNewData: getNewData,
    );

    r.fold(
      (l) {
        emit(
          state.copyWith(
            getUserFriendsState: state.getUserFriendsState.asLoadingFailed(
              r.toString(),
            ),
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            getUserFriendsState: state.getUserFriendsState.asLoadingSuccess(
              friendConnections: r.friendConnections,
              success: true,
            ),
          ),
        );
      },
    );
  }

  Future<void> deleteUserFriends(int id) async {
    emit(
      state.copyWith(
        getUserFriendsState: state.getUserFriendsState.asLoading(),
      ),
    );

    final r = await connectionsRepo.deleteFriendConnections(
      id,
    );

    r.fold(
      (l) {
        emit(
          state.copyWith(
            getUserFriendsState: state.getUserFriendsState.asLoadingFailed(
              r.toString(),
            ),
          ),
        );
      },
      (r) async {
        emit(
          state.copyWith(
            getUserFriendsState: state.getUserFriendsState.asLoadingSuccess(
              success: true,
            ),
          ),
        );
        await getUserFriends(getNewData: true);
      },
    );
  }

  Future<void> updateName(String name) async {
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoading(),
      ),
    );

    final r = await authRepo.updateUserWithDataBase(
      name: name,
    );

    r.fold(
      (l) => emit(
        state.copyWith(
          userProfileState: state.userProfileState.asLoadingFailed(
            r.toString(),
          ),
        ),
      ),
      (r) => getProfileData(getNewData: true),
    );
  }

  Future<void> updatePicture(File? photo, int? avatarId) async {
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoading(),
      ),
    );

    final r = await authRepo.updateUserWithDataBase(
      photo: photo,
      avatarId: avatarId,
    );

    r.fold(
      (l) => emit(
        state.copyWith(
          userProfileState: state.userProfileState.asLoadingFailed(
            r.toString(),
          ),
        ),
      ),
      (r) => getProfileData(getNewData: true),
    );
  }

  Future<void> changeLang(String lang, BuildContext context) async {
    emit(
      state.copyWith(
        changeLangState: state.changeLangState.asLoading(),
      ),
    );
    final data = await langRepo.setLang(lang, context);
    data.fold(
      (l) => emit(
        state.copyWith(
          changeLangState: state.changeLangState.asLoadingFailed(l),
        ),
      ),
      (r) => emit(
        state.copyWith(
          changeLangState: state.changeLangState.asLoadingSuccess(success: true),
        ),
      ),
    );
  }

  Future<void> pickUpImage() async {
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoading(),
      ),
    );
    final image = await authRepo.pickUpGalleryImage();
    image.fold(
      (l) => emit(
        state.copyWith(
          userProfileState: state.userProfileState.asLoadingFailed(l),
        ),
      ),
      (r) {
        emit(
          state.copyWith(
            userProfileState: state.userProfileState.asLoadingSuccess(
              success: true,
              pickedImagePath: r.imagePath,
              pickedImageFile: r.imageFile,
              userData: authRepo.user,
            ),
          ),
        );
      },
    );
  }

  Future<void> selectImage({required RecentlyPhotoData image}) async {
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoading(),
      ),
    );
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoadingSuccess(
            success: true, pickedImagePath: image.avatarUrl, userData: authRepo.user, recentlyPhotoData: image),
      ),
    );
  }

  Future<void> getHistoricalImage() async {
    emit(
      state.copyWith(
        pickUpImageState: state.pickUpImageState.asLoading(),
      ),
    );
    final data = await authRepo.getRecentlyProfileImages();

    data.fold((l) {
      emit(
        state.copyWith(
          pickUpImageState: state.pickUpImageState.asLoadingFailed(
            l.toString(),
          ),
        ),
      );
    }, (r) {
      emit(
        state.copyWith(
          pickUpImageState: state.pickUpImageState.asLoadingSuccess(success: true, recentlyPhotoData: r.photosList),
        ),
      );
    });
  }

  Future<void> clearPickUpImage() async {
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoading(),
      ),
    );
    emit(
      state.copyWith(
        userProfileState: state.userProfileState.asLoadingSuccess(
          success: true,
          userData: authRepo.user,
        ),
      ),
    );
  }

  Future<void> getAboutAppInfo() async {
    emit(
      state.copyWith(
        getAboutAppData: state.getAboutAppData.asLoading(),
      ),
    );
    final data = await authRepo.getAboutAppInfo();

    data.fold((l) {
      debugPrint(l.message.toString() + 'kkkkkkkkkkkkkkkkkkkkkkkkk');
      emit(
        state.copyWith(
          getAboutAppData: state.getAboutAppData.asLoadingFailed(
            error: l.toString(),
            success: false,
          ),
        ),
      );
    }, (r) {
      debugPrint(r.aboutAppData.appEmail.toString());
      emit(
        state.copyWith(
          getAboutAppData: state.getAboutAppData.asLoadingSuccess(success: true, aboutAppData: r.aboutAppData),
        ),
      );
    });
  }

  Future<void> getAllUserContactsFromBe({required bool isPagination, FilterParameters? filterParameters}) async {
    if (isPagination) {
      emit(
        state.copyWith(
          getDBUserContactsState: state.getDBUserContactsState.asPaginationLoading(
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
          getDBUserContactsState: state.getDBUserContactsState.asLoading(),
        ),
      );
    }

    final f = await contractRepo.getUserContactFromDataBase(filterParameters);
    f.fold(
      (l) => {
        emit(
          state.copyWith(
            getDBUserContactsState: state.getDBUserContactsState.asLoadingFailed(
              l.toString(),
            ),
          ),
        )
      },
      (r) => {
        emit(
          state.copyWith(
            getDBUserContactsState: state.getDBUserContactsState.asLoadingSuccess(
              success: true,
              contactsList: r,
            ),
          ),
        ),
      },
    );
  }
}
