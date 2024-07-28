import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house/helper/firebase_auth_error_translator.dart';
import 'package:house/auth/methods/auth/auth_platform.dart';
import 'package:house/auth/methods/auth/auth_shared_methods.dart';
import 'package:house/main.dart';

class NativeAuthMethods with AuthSharedMethods implements AuthPlatform {
 
  @override
  Future<UserCredential> signInWithGoogle() async {
    return await handleAuthErrors(() async {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    });
  }

  @override
  Future<void> signInWithFacebook() {
    throw UnimplementedError();
  }

  @override
  Future<String> sendSmsCode({
    required String phoneNo,
  }) async {
    final prefix = '+886${phoneNo.substring(1)}';
    Completer<String> completer = Completer();

    await auth
        .verifyPhoneNumber(
      phoneNumber: prefix,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        completer.completeError(AuthErrorTranslator.tw(e));
      },
      codeSent: (String verificationId, int? resendToken) {
        completer.complete(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        completer.completeError('驗證逾時');
      },
    )
        .catchError((e) {
      completer.completeError('驗證失敗 : $e');
    });

    return completer.future;
  }

  @override
  Future<void> confirmSmsCode({
    required String smsCode,
    String? verificationId,
    ConfirmationResult? confirmationResult,
  }) async {
    return await handleAuthErrors(() async {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: smsCode,
      );
      await auth.signInWithCredential(credential);
    });
  }

 

}
