import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/app_config.dart';
import 'package:mostaql/core/cache/cache_helper.dart';
import 'package:mostaql/pages/splash/bloc/splash_state.dart';
import 'package:mostaql/repos/auth_repo.dart';

class SplashBloc extends Cubit<SplashState> {
  SplashBloc(this.authRepo, this.cacheHelper) : super(const SplashState());

  final AuthRepo authRepo;
  final CacheHelper cacheHelper;

  checkUser() async {
    emit(state.asLoading());
    final checkUser = await authRepo.checkUser();
    final checkOnBoardingSkipped = await cacheHelper.has(kUserOnBoardIsSkipped);
    emit(state.asLoadingSuccess(checkUser, checkOnBoardingSkipped));
  }
}
