// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiJDY15P4hRNQcZKn8fIekoA9COcUIeDU',
    appId: '1:1051843546353:android:aa52b3b6257e611cfc2d50',
    messagingSenderId: '1051843546353',
    projectId: 'maarfy-c8634',
    storageBucket: 'maarfy-c8634.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCi00rjGmRP-iCrSI88OTOGHawDWTd8C9E',
    appId: '1:1051843546353:ios:3dae9f2023cf90d3fc2d50',
    messagingSenderId: '1051843546353',
    projectId: 'maarfy-c8634',
    storageBucket: 'maarfy-c8634.appspot.com',
    androidClientId: '1051843546353-57qb4q5r2ub1p2qth8g0esl4v4ctpcib.apps.googleusercontent.com',
    iosClientId: '1051843546353-8kvudggm59aih3gm8tvkmmlqkf611t3b.apps.googleusercontent.com',
    iosBundleId: 'com.algoriza.maarfy',
  );
}
