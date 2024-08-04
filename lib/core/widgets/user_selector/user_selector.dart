import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/core/app/app_bloc.dart';

import '../../../models/user_model.dart';

class UserSelector extends StatelessWidget {
  const UserSelector({Key? key, required this.builder}) : super(key: key);
  final Widget Function(BuildContext context, UserData? user) builder;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AppBloc, AppState, UserData?>(
        bloc: AppBloc(), selector: (state) => state.user, builder: (context, user) => builder(context, user));
  }
}
