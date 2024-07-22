import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:house/auth/methods/auth/auth_platform.dart';
import 'package:house/auth/methods/auth/native_auth_methods.dart';
import 'package:house/auth/methods/auth/web_auth_methods.dart';

class AuthPlatformFactory {
  static AuthPlatform get() {
    if (kIsWeb) {
      return WebAuthMethods();
    } else if (Platform.isAndroid || Platform.isIOS) {
      return NativeAuthMethods();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
