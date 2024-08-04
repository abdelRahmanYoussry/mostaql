import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mostaql/core/utils/loading_state.dart';

part 'about_app_state.dart';

class AboutAppCubit extends Cubit<AboutAppState> {
  AboutAppCubit() : super(const AboutAppState());

  static AppInfoModel? appInfo;

  Future<void> getAppInfo() async {
    print("inside getAppInfo");

    emit(state.copyWith(getAppInfoState: state.getAppInfoState.asLoading()));

    Future.delayed(const Duration(seconds: 1), () {
      appInfo = AppInfoModel(email: 'alogiriza@gmail.com', phone: '002132123213', version: '1.1.3');

      emit(state.copyWith(
          getAppInfoState: state.getAppInfoState.asLoadingSuccess(
        success: true,
      )));
    });
  }
}
