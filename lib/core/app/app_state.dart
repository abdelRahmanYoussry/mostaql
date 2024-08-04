import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';

class AppState extends Equatable {
  final UserData? user;

  const AppState({
    this.user,
  });

  AppState copyWith({
    UserData? user,
    bool userNull = false,
  }) =>
      AppState(
        user: userNull ? user : user ?? this.user,
      );

  bool get isLoggedIn => user != null;

  @override
  List<Object?> get props => [user];
}
