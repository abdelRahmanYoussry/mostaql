part of 'about_app_cubit.dart';

class AboutAppState extends Equatable {
  final GetAppInfoState getAppInfoState;

  const AboutAppState({this.getAppInfoState = const GetAppInfoState()});

  copyWith({
    GetAppInfoState? getAppInfoState,
  }) {
    return AboutAppState(
      getAppInfoState: getAppInfoState ?? this.getAppInfoState,
    );
  }

  @override
  List<Object?> get props => [getAppInfoState];
}

class GetAppInfoState extends Equatable {
  final LoadingState loadingState;
  final bool? success;
  final String? error;

  // final AppInfoModel? appInfoModel;

  const GetAppInfoState({
    this.loadingState = const LoadingState(),
    this.success,
    this.error,
    // this.appInfoModel
  });

  GetAppInfoState asLoading() => const GetAppInfoState(
        loadingState: LoadingState.loading(),
      );

  GetAppInfoState asLoadingSuccess(
          {bool? success, AppInfoModel? appInfoModel}) =>
      GetAppInfoState(
        success: success,
        // appInfoModel: appInfoModel
      );

  GetAppInfoState asLoadingFailed(String error) => GetAppInfoState(
        error: error,
      );

  @override
  List<Object?> get props => [
        loadingState,
        success,
        error,
      ];
}

// to move to separate file
class AppInfoModel {
  final String email;
  final String phone;
  final String version;

  AppInfoModel(
      {required this.email, required this.phone, required this.version});
}
