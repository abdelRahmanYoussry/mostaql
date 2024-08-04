import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';
import 'package:mostaql/core/utils/remote/api_helper.dart';
import 'package:mostaql/repos/connections_repo.dart';

import '../../../../models/friend_connection_response.dart';

part 'maarfy_settings_state.dart';

class MaarfySettingsCubit extends Cubit<MaarfySettingsState> {
  MaarfySettingsCubit(this.connectionsRepo) : super(const MaarfySettingsState());
  final ConnectionsRepo connectionsRepo;

  Future<void> shareConnection(String phone) async {
    emit(
      state.copyWith(
        shareConnectionState: state.shareConnectionState.asLoading(),
      ),
    );

    final r = await connectionsRepo.shareConnection(phone);

    r.fold(
        (l) => emit(
              state.copyWith(
                shareConnectionState: state.shareConnectionState.asLoadingFailed(l.message),
              ),
            ), (r) async {
      emit(
        state.copyWith(
          shareConnectionState: state.shareConnectionState.asLoadingSuccess(success: true),
        ),
      );
      await getUserFriends(getNewData: true);
    });
  }

  Future<void> getUserFriends({required bool getNewData}) async {
    emit(
      state.copyWith(
        getUserFriendsState: state.getUserFriendsState.asLoading(),
      ),
    );

    final r = await connectionsRepo.getFriendConnections(getNewData: getNewData);

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
            getUserFriendsState:
                state.getUserFriendsState.asLoadingSuccess(friendConnections: r.friendConnections, success: true),
          ),
        );
        eventBus.fire(FetchSharedContracts());
      },
    );
  }

  Future<void> deleteUserFriends(int id) async {
    emit(
      state.copyWith(
        getUserFriendsState: state.getUserFriendsState.asLoading(),
      ),
    );

    final r = await connectionsRepo.deleteFriendConnections(id);

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
            getUserFriendsState: state.getUserFriendsState.asLoadingSuccess(success: true),
          ),
        );
        await getUserFriends(getNewData: true);
      },
    );
  }
}
