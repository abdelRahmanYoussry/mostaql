import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import '../di/di.dart';
import 'app_state.dart';

export 'app_state.dart';

class AppBloc extends Cubit<AppState> {
  AppBloc._() : super(const AppState());

  factory AppBloc() {
    if (!di.isRegistered<AppBloc>()) {
      di.registerSingleton<AppBloc>(AppBloc._());
    }
    return di<AppBloc>();
  }

  @override
  Future<void> close() {
    di.unregister<AppBloc>();
    return super.close();
  }

  loggedIn(UserData user) => emit(state.copyWith(user: user));

  loggedOut() => emit(state.copyWith(user: null, userNull: true));
}
