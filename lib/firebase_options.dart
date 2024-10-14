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
    apiKey: 'AIzaSyBqNjBad696yHTHFRhU5oWWzEmHkO3Z8Pw',
    appId: '1:513501503905:web:1c890fa4886a257a73ebe0',
    messagingSenderId: '513501503905',
    projectId: 'testing-6d525',
    authDomain: 'testing-6d525.firebaseapp.com',
    storageBucket: 'testing-6d525.appspot.com',
    measurementId: 'G-2J6XVTPV44',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBLupkb5R8wM0djQ9VyRSq23FirESRQlYc',
    appId: '1:513501503905:android:cad85b3babe8d36073ebe0',
    messagingSenderId: '513501503905',
    projectId: 'testing-6d525',
    storageBucket: 'testing-6d525.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBMqck7YJYIBL9ZEoLzIBTsI4IIv3hwnIU',
    appId: '1:513501503905:ios:baeb2f6f3935c9f873ebe0',
    messagingSenderId: '513501503905',
    projectId: 'testing-6d525',
    storageBucket: 'testing-6d525.appspot.com',
    iosBundleId: 'com.example.productManagement',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBMqck7YJYIBL9ZEoLzIBTsI4IIv3hwnIU',
    appId: '1:513501503905:ios:baeb2f6f3935c9f873ebe0',
    messagingSenderId: '513501503905',
    projectId: 'testing-6d525',
    storageBucket: 'testing-6d525.appspot.com',
    iosBundleId: 'com.example.productManagement',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqNjBad696yHTHFRhU5oWWzEmHkO3Z8Pw',
    appId: '1:513501503905:web:bf175da1fec7a2cd73ebe0',
    messagingSenderId: '513501503905',
    projectId: 'testing-6d525',
    authDomain: 'testing-6d525.firebaseapp.com',
    storageBucket: 'testing-6d525.appspot.com',
    measurementId: 'G-0SJZCJNWTK',
  );
}
