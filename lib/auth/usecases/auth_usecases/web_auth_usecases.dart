import 'package:firebase_auth/firebase_auth.dart';
import 'package:house/auth/helper/firebase_auth_error_translator.dart';
import 'package:house/auth/usecases/auth_usecases/auth_usecases.dart';

class WebAuthUsecases implements AuthUsecases {
  final FirebaseAuth _firebaseAuth;

  WebAuthUsecases({required FirebaseAuth firebaseAuth})
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
  }) async =>
      await handleAuthErrors(() async {
        final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      });

  @override
  Future<UserCredential> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');

    return await _firebaseAuth.signInWithPopup(googleProvider);
  }

  @override
  Future<void> signInWithFacebook() async {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    await _firebaseAuth.signInWithPopup(facebookProvider);
  }

  @override
  Future<ConfirmationResult> sendSmsCode({
    required String phoneNo,
  }) async {
    final prefix = '+886${phoneNo.substring(1)}';

    return await handleAuthErrors(() async {
      return await _firebaseAuth.signInWithPhoneNumber(prefix);
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
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    });
  }
}
