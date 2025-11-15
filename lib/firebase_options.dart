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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAmmS1szu1r4-QL1fRhd4weI6K8BIMAYnk',
    appId: '1:1037756845903:web:2a38dbd162bfd9edb9bf3a',
    messagingSenderId: '1037756845903',
    projectId: 'nudge-88445',
    authDomain: 'nudge-88445.firebaseapp.com',
    storageBucket: 'nudge-88445.firebasestorage.app',
    measurementId: 'G-YHC556ENYX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIDN0PDGVEHuST0Fy5BSFNLoz4ewT3s0A',
    appId: '1:1037756845903:android:9a4c1c64efcab5ddb9bf3a',
    messagingSenderId: '1037756845903',
    projectId: 'nudge-88445',
    storageBucket: 'nudge-88445.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDIDN0PDGVEHuST0Fy5BSFNLoz4ewT3s0A',
    appId: '1:1037756845903:ios:771cd0ee3b47ffa1b9bf3a',
    messagingSenderId: '1037756845903',
    projectId: 'nudge-88445',
    storageBucket: 'nudge-88445.firebasestorage.app',
    iosBundleId: 'com.company.nudge',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDIDN0PDGVEHuST0Fy5BSFNLoz4ewT3s0A',
    appId: '1:1037756845903:ios:771cd0ee3b47ffa1b9bf3a',
    messagingSenderId: '1037756845903',
    projectId: 'nudge-88445',
    storageBucket: 'nudge-88445.firebasestorage.app',
    iosBundleId: 'com.company.nudge.RunnerTests',
  );
}