import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/utils/loading_state.dart';

part 'image_seleciton_state.dart';

class ImageSelectionCubit extends Cubit<ImageSelectionState> {
  ImageSelectionCubit() : super(const ImageSelectionState());

// for temp use
  //todo remove static images list after handle with api
  final List<String> images = [
    "https://img.freepik.com/premium-photo/arabic-mosaic-background-islamic-pattern-wall-with-sunlight-ai-generative_875746-357.jpg?w=740",
    "https://img.freepik.com/free-photo/painting-mountain-lake-with-mountain-background_188544-9126.jpg",
    "https://images.ctfassets.net/hrltx12pl8hq/01rJn4TormMsGQs1ZRIpzX/16a1cae2440420d0fd0a7a9a006f2dcb/Artboard_Copy_231.jpg?fit=fill&w=600&h=600",
    "https://live.staticflickr.com/65535/52211883534_f45cb76810_z.jpg",
  ];

  Future<void> getProfileImages() async {
    emit(
      state.copyWith(
        getProfileImagesState: state.getProfileImagesState.asLoading(),
      ),
    );

    Future.delayed(
      const Duration(seconds: 2),
      () {
        emit(
          state.copyWith(
            getProfileImagesState: state.getProfileImagesState.asLoadingSuccess(images: images),
          ),
        );
      },
    );
  }
}
