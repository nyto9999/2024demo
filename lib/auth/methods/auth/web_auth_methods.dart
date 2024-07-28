import 'package:firebase_auth/firebase_auth.dart';
import 'package:house/helper/firebase_auth_error_translator.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';
import 'package:house/auth/methods/auth/auth_shared_methods.dart';
import 'package:house/main.dart';

class WebAuthMethods with AuthSharedMethods implements AuthPlatform {
  @override
  Future<UserCredential> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');

    return await auth.signInWithPopup(googleProvider);
  }

  @override
  Future<void> signInWithFacebook() async {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    await auth.signInWithPopup(facebookProvider);
  }

  @override
  Future<ConfirmationResult> sendSmsCode({
    required String phoneNo,
  }) async {
    final prefix = '+886${phoneNo.substring(1)}';

    return await handleAuthErrors(() async {
      return await auth.signInWithPhoneNumber(prefix);
    });
  }

  @override
  Future<void> confirmSmsCode({
    required String smsCode,
    String? verificationId,
    ConfirmationResult? confirmationResult,
  }) async {
    return await handleAuthErrors(() async {
      await confirmationResult?.confirm(smsCode);
    });
  }

  @override
  Future<void> forgetPassword(String email) async {
    return await handleAuthErrors(() async {
      await auth.sendPasswordResetEmail(email: email);
    });
  }
}
