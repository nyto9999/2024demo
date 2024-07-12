import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
 // ignore: depend_on_referenced_packages
 import 'package:local_auth_darwin/local_auth_darwin.dart';
 
 

class LocalAuthUsecases {
  final LocalAuthentication localAuth;
  bool isAvailable = false;

  LocalAuthUsecases({required this.localAuth}) {
    if (!kIsWeb) {
      _checkAvailability();
    }
  }

  Future<void> _checkAvailability() async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;
    List<BiometricType> availableBiometrics =
        await localAuth.getAvailableBiometrics();
    isAvailable =
        !kIsWeb && canCheckBiometrics && availableBiometrics.isNotEmpty;

    debugPrint('生物識別可用: $isAvailable');
    if (isAvailable) {
      debugPrint(
          '可用類型: ${availableBiometrics.map(_biometricTypeToString).join(", ")}');
    }
  }

  String _biometricTypeToString(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return '面部識別';
      case BiometricType.fingerprint:
        return '指紋';
      case BiometricType.strong:
        return '強生物識別';
      case BiometricType.weak:
        return '弱生物識別';
      default:
        return '未知';
    }
  }

  Future<bool> authenticate() async {
    if (!isAvailable) throw '不支援生物識別';

    try {
      return await localAuth.authenticate(
        authMessages: const [

          IOSAuthMessages(
            cancelButton: '取消',
          )
        ],
        localizedReason: '請進行生物識別認證',
        options: const AuthenticationOptions(stickyAuth: true, useErrorDialogs: true),
      );
    } on PlatformException catch (e) {
      debugPrint('認證錯誤: $e');
      return false;
    }
  }

  Future<void> stopAuthentication() async {
    localAuth.stopAuthentication();
  }
}
