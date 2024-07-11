import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';
import 'package:house/auth/usecases/auth_usecases/native_auth_usecases.dart';
import 'package:house/auth/usecases/auth_usecases/web_auth_usecases.dart';

class AuthUsecaseFactory {
  static AuthUsecases get(FirebaseAuth firebaseAuth) {
    if (kIsWeb) {
      return WebAuthUsecases(firebaseAuth: firebaseAuth);
    } else if (Platform.isAndroid || Platform.isIOS) {
      return NativeAuthUsecases(firebaseAuth: firebaseAuth);
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
