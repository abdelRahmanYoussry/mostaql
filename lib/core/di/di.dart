import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../firebase_options.dart';
import '../../pages/aboutApp/app_review_service.dart';
import '../../pages/aboutApp/cubit/about_app_cubit.dart';
import '../../pages/addPerson/bloc/add_person_bloc.dart';
import '../../pages/bottomNavLayout/bloc/bottom_nav_bloc.dart';
import '../../pages/chat/bloc/chat_bloc.dart';
import '../../pages/filter/filter_bloc.dart';
import '../../pages/home/bloc/home_bloc.dart';
import '../../pages/placeOfBirth/place_of_birth_bloc.dart';
import '../../pages/placeOfWork/place_of_work_bloc.dart';
import '../../pages/settings/cubit/maarfy_settings_cubit/maarfy_settings_cubit.dart';
import '../../pages/settings/cubit/settings_cubit.dart';
import '../../pages/splash/bloc/splash_bloc.dart';
import '../../pages/updateContact/bloc/update_contact_bloc.dart';
import '../../repos/add_person_repo.dart';
import '../../repos/auth_repo.dart';
import '../../repos/chat_repo.dart';
import '../../repos/connections_repo.dart';
import '../../repos/contract_repo.dart';
import '../../repos/home_repo.dart';
import '../../repos/lang_repo.dart';
import '../cache/cache_helper.dart';
import '../utils/notifications/setup_local_notification.dart';
import '../utils/notifications/setup_notifications.dart';
import '../utils/remote/api_helper.dart';
import '../utils/remote/dio_helper.dart';

final di = GetIt.I;

Future initializeDependencies() async {
  //shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerSingleton(sharedPreferences);

  //dio
  di.registerSingleton(
    Dio(),
  );

  // cache
  di.registerSingleton(
    CacheHelper(sharedPreferences),
  );

  // di.registerLazySingleton(() =>CacheManager(di()));
  //

  // api helpers
  di.registerLazySingleton<ApiHelper>(
    () => ApiImpl(),
  );
  di.registerLazySingleton<DioHelper>(
    () => DioImpl(),
  );

  // notificationsFCM
  di.registerLazySingleton<SetupFCM>(
    () => SetupFCM(
      langRepo: di(),
      cacheHelper: di(),
      apiHelper: di(),
    ),
  );
  // notifications Local
  di.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationService(),
  );
  // language
  di.registerSingleton(
    LangRepo(
      apiHelper: di(),
      cacheHelper: di(),
    ),
  );

  //blocs

  di.registerFactory(
    () => SettingsPageCubit(di(), di(), di(), di()),
  );

  di.registerFactory(
    () => AboutAppCubit(),
  );

  di.registerFactory(
    () => MaarfySettingsCubit(
      di(),
    ),
  );

  di.registerFactory(
    () => BottomNavBloc(
      authRepo: di(),
    ),
  );

  di.registerFactory(
    () => SplashBloc(
      di(),
      di(),
    ),
  );
  di.registerFactory(
    () => AddPersonBloc(
      addPersonRepo: di(),
      contractRepo: di(),
    ),
  );
  di.registerFactory(
    () => HomeBloc(
      homeRepo: di(),
      contractRepo: di(),
    ),
  );

  di.registerFactory(
    () => UpdateContactBloc(
      contractRepo: di(),
    ),
  );

  di.registerFactory(
    () => PlaceOfWorkBloc(
      addPersonRepo: di(),
    ),
  );

  di.registerFactory(
    () => PlaceOfBirthBloc(
      addPersonRepo: di(),
    ),
  );

  di.registerFactory(
    () => FilterBloc(
      homeRepo: di(),
    ),
  );

  di.registerFactory(
    () => ChatAiBloc(
      authRepo: di(),
      chatRepo: di(),
    ),
  );
  // fireBase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  di.registerSingleton(FirebaseAuth.instance);

  //repos
  di.registerSingleton(
    AuthRepo(
      di(),
      di(),
      di(),
      di(),
      di(),
      di(),
    ),
  );

  di.registerSingleton(
    HomeRepo(
      di(),
      di(),
      di(),
      di(),
      di(),
    ),
  );

  di.registerSingleton(
    AddPersonRepo(
      di(),
      di(),
      di(),
      di(),
      di(),
    ),
  );

  di.registerLazySingleton<ConnectionsRepo>(
    () => ConnectionsRepoImpl(
      di(),
      di(),
      di(),
      di(),
    ),
  );

  di.registerLazySingleton<ContractRepo>(
    () => ContractRepo(
      di(),
      di(),
      di(),
      di(),
    ),
  );
  di.registerLazySingleton<ChatAiRepo>(
    () => ChatAiRepo(
      di(),
      di(),
      di(),
      di(),
      di(),
    ),
  );

  di.registerLazySingleton<AppReviewService>(
    () => AppReviewService(),
  );
}
