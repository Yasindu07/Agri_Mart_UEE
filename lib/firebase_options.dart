// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyAA9l_FkU_EBU1Yw6nhqTdbSJ8RavMGu7c',
    appId: '1:658832220248:web:007cc7cda0bcb09a0b6a2d',
    messagingSenderId: '658832220248',
    projectId: 'agromart-850a8',
    authDomain: 'agromart-850a8.firebaseapp.com',
    storageBucket: 'agromart-850a8.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAngZMI85OQgt4YuPkVKHRVLkGBC-6KiS4',
    appId: '1:658832220248:android:82056512f25ae67c0b6a2d',
    messagingSenderId: '658832220248',
    projectId: 'agromart-850a8',
    storageBucket: 'agromart-850a8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCbBQAPTNe5UzCqrrkEMv6tsYbvZ9xRA3k',
    appId: '1:658832220248:ios:890ccdc9089ed1910b6a2d',
    messagingSenderId: '658832220248',
    projectId: 'agromart-850a8',
    storageBucket: 'agromart-850a8.appspot.com',
    iosBundleId: 'com.example.agroMart',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCbBQAPTNe5UzCqrrkEMv6tsYbvZ9xRA3k',
    appId: '1:658832220248:ios:890ccdc9089ed1910b6a2d',
    messagingSenderId: '658832220248',
    projectId: 'agromart-850a8',
    storageBucket: 'agromart-850a8.appspot.com',
    iosBundleId: 'com.example.agroMart',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAA9l_FkU_EBU1Yw6nhqTdbSJ8RavMGu7c',
    appId: '1:658832220248:web:0fbee6ff5b74fc260b6a2d',
    messagingSenderId: '658832220248',
    projectId: 'agromart-850a8',
    authDomain: 'agromart-850a8.firebaseapp.com',
    storageBucket: 'agromart-850a8.appspot.com',
  );
}