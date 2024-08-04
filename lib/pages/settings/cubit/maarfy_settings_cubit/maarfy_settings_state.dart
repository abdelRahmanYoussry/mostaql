part of 'maarfy_settings_cubit.dart';

class MaarfySettingsState extends Equatable {
  final ShareConnectionState shareConnectionState;
  final GetUserFriendsState getUserFriendsState;

  const MaarfySettingsState({
    this.shareConnectionState = const ShareConnectionState(),
    this.getUserFriendsState = const GetUserFriendsState(),
  });

  copyWith({
    ShareConnectionState? shareConnectionState,
    GetUserFriendsState? getUserFriendsState,
  }) {
    return MaarfySettingsState(
        shareConnectionState: shareConnectionState ?? this.shareConnectionState,
        getUserFriendsState: getUserFriendsState ?? this.getUserFriendsState);
  }

  @override
  List<Object?> get props => [shareConnectionState, getUserFriendsState];
}

class ShareConnectionState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;

  const ShareConnectionState({this.success, this.loadingState = const LoadingState(), this.error});

  ShareConnectionState asLoading() => const ShareConnectionState(
        loadingState: LoadingState.loading(),
      );

  ShareConnectionState asLoadingSuccess({bool? success}) => ShareConnectionState(success: success);

  ShareConnectionState asLoadingFailed(String error) => ShareConnectionState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error];
}

class GetUserFriendsState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<FriendConnectionModel>? friendConnections;

  const GetUserFriendsState(
      {this.success, this.loadingState = const LoadingState(), this.error, this.friendConnections});

  GetUserFriendsState asLoading() => const GetUserFriendsState(
        loadingState: LoadingState.loading(),
      );

  GetUserFriendsState asLoadingSuccess({bool? success, List<FriendConnectionModel>? friendConnections}) =>
      GetUserFriendsState(success: success, friendConnections: friendConnections);

  GetUserFriendsState asLoadingFailed(String error) => GetUserFriendsState(
        error: error,
      );

  @override
  List<Object?> get props => [success, loadingState, error, friendConnections];
}
