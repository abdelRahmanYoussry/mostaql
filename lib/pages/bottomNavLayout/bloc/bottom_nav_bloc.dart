import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mostaql/repos/auth_repo.dart';

import 'bottom_nav_state.dart';

class BottomNavBloc extends Cubit<BottomNavState> {
  BottomNavBloc({required this.authRepo}) : super(const BottomNavState());

  final AuthRepo authRepo;
}
