import 'package:firebase_auth/firebase_auth.dart';
import 'package:house/auth/methods/auth/auth_shared_methods.dart';
import 'native_auth_methods.dart';
import 'web_auth_methods.dart';

///shortcuts for child usecases
///[NativeAuthMethods]
///[WebAuthMethods]

abstract class AuthPlatform with AuthSharedMethods {
  //第三方登入
  Future<UserCredential> signInWithGoogle();
  Future<void> signInWithFacebook();

  //簡訊登入
  Future<dynamic> sendSmsCode({required String phoneNo});

  Future<void> confirmSmsCode({
    required String smsCode,
    String? verificationId, // native
    ConfirmationResult? confirmationResult, // web
  });


}
