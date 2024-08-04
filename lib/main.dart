import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mostaql/pages/splash/splash_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:size_config/size_config.dart';

import 'app_config.dart';
import 'core/app/app_bloc.dart';
import 'core/di/di.dart';
import 'core/navigation/nav.dart';
import 'core/navigation/nav_obs.dart';
import 'core/theme/colors.dart';
import 'core/theme/theme.dart';
import 'models/user_model.dart';

int _lastVersion = 4;
PackageInfo? packageInfo;
String? token; // for temp use
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   systemNavigationBarColor: Colors.white,
  // ));
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: lightGrey, statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  //todo remove at production
  final prefs = await SharedPreferences.getInstance();
  final savedVersion = prefs.getInt('saved_version') ?? 0;
  if (_lastVersion != savedVersion) {
    await prefs.clear();
    await prefs.setInt('saved_version', _lastVersion);
    await HydratedBloc.storage.clear();
  }
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();

  await _getUserData(prefs);
  packageInfo = await PackageInfo.fromPlatform();
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

_getUserData(SharedPreferences prefs) async {
  final user = prefs.get(kUserKey);

  if (user != null && user is Map<String, dynamic>) {
    final UserModel userModel = UserModel.fromJson(user);
    AppBloc().loggedIn(userModel.userData);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    AppBloc().close();
    super.dispose();
  }

  @override
  void initState() {
    //todo remove this after add change lang ui and methods
    // set default lang to arabic
    // di<LangRepo>().setLang('ar');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      path: 'assets/langs',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: SizeConfigInit(
        referenceWidth: 430,
        referenceHeight: 932,
        builder: (context, orientation) => MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: Nav.mainNavKey,
          navigatorObservers: [NavObs('MAIN')],
          localizationsDelegates: [CountryLocalizations.delegate, ...context.localizationDelegates],
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: buildAppTheme(),
          home: const SplashPage(),
          // home: const ConfirmNamePage(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
