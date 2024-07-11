import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house/auth/helper/firebase_auth_error_translator.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

class NativeAuthUsecases implements AuthUsecases {
  final FirebaseAuth _firebaseAuth;

  NativeAuthUsecases({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await handleAuthErrors(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    });
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await handleAuthErrors(() async {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential;
    });
  }

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

    await _firebaseAuth
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
      await _firebaseAuth.signInWithCredential(credential);
    });
  }

  @override
  Future<void> forgetPassword(String email) async {
    return await handleAuthErrors(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }
}
