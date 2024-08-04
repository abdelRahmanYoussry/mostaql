part of 'image_seleciton_cubit.dart';

class ImageSelectionState extends Equatable {
  final GetProfileImagesState getProfileImagesState;

  const ImageSelectionState({
    this.getProfileImagesState = const GetProfileImagesState(),
  });

  copyWith({
    GetProfileImagesState? getProfileImagesState,
  }) {
    return ImageSelectionState(
      getProfileImagesState: getProfileImagesState ?? this.getProfileImagesState,
    );
  }

  @override
  List<Object?> get props => [
        getProfileImagesState,
      ];
}

class GetProfileImagesState extends Equatable {
  final bool? success;
  final LoadingState loadingState;
  final String? error;
  final List<String>? images;

  const GetProfileImagesState({this.success, this.loadingState = const LoadingState(), this.error, this.images});

  GetProfileImagesState asLoading() => const GetProfileImagesState(
        loadingState: LoadingState.loading(),
      );

  GetProfileImagesState asLoadingSuccess({bool? success, List<String>? images}) => GetProfileImagesState(
        success: success,
        images: images,
      );

  GetProfileImagesState asLoadingFailed(String error) => GetProfileImagesState(
        error: error,
      );

  @override
  List<Object?> get props => [
        success,
        loadingState,
        error,
        images,
      ];
}
