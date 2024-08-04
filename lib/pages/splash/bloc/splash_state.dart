import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';

class SplashState extends Equatable {
  final bool? hasUser;
  final bool? isOnBoardingSkipped;
  final LoadingState loadingState;
  final String? error;

  const SplashState({
    this.hasUser,
    this.isOnBoardingSkipped,
    this.loadingState = const LoadingState(),
    this.error,
  });

  SplashState asLoading() => const SplashState(
        loadingState: LoadingState.loading(),
      );

  SplashState asLoadingSuccess(
    bool hasUser,
    bool isOnBoardSkipped,
  ) =>
      SplashState(
        hasUser: hasUser,
        isOnBoardingSkipped: isOnBoardSkipped,
      );

  SplashState asLoadingFailed(String error) => SplashState(
        error: error,
      );

  @override
  List<Object?> get props => [
        hasUser,
        loadingState,
        error,
      ];
}
