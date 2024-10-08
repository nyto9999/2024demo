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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBksfQyA7Hp5UdLu3v9X_6HxWw77-atZuo',
    appId: '1:548071695548:web:faadd362ec9f68ab1e9cb9',
    messagingSenderId: '548071695548',
    projectId: 'house-ff670',
    authDomain: 'house-ff670.firebaseapp.com',
    databaseURL:
        'https://house-ff670-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'house-ff670.appspot.com',
    measurementId: 'G-6K14FM7SHP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDW_mUPH9hoSAPOrfuObNzhRPfliFZA3ps',
    appId: '1:548071695548:android:61107541c193d62a1e9cb9',
    messagingSenderId: '548071695548',
    projectId: 'house-ff670',
    databaseURL:
        'https://house-ff670-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'house-ff670.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIhIQtLyP5lRXycaUrtGJl7of6SQLqD_M',
    appId: '1:548071695548:ios:d0e42b577a90440d1e9cb9',
    messagingSenderId: '548071695548',
    projectId: 'house-ff670',
    databaseURL:
        'https://house-ff670-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'house-ff670.appspot.com',
    androidClientId:
        '548071695548-f5tm8d43utdq9t7pvjjv7q66me2ufnbe.apps.googleusercontent.com',
    iosClientId:
        '548071695548-c5pbpdr4gtqjcvcm2tmhif4iiv19l3vn.apps.googleusercontent.com',
    iosBundleId: 'com.example.house',
  );
}
