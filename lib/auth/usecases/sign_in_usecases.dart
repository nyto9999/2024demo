import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:house/auth/usecases/firebase_auth_error_translator.dart';

/// - [登录流程](file://./../diagrams/login_form_flow.wsd)
class SignInUsecases {
  SignInUsecases({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  final FirebaseAuth _firebaseAuth;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthErrorTranslator.tw(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      kIsWeb ? await _signInWithGoogleWeb() : await _signInWithGoogleNative();
    } on FirebaseAuthException catch (e) {
      throw AuthErrorTranslator.tw(e);
    }
  }

  Future<void> siginInWithFacebook() async {
    try {
      kIsWeb
          ? await _signInWithFacebookWeb()
          : await _signInWithFacebookNative();
    } on FirebaseAuthException catch (e) {
      throw AuthErrorTranslator.tw(e);
    }
  }
//test
  Future<void> forgetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthErrorTranslator.tw(e);
    }
  }

  Future<void> _signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');

    await _firebaseAuth.signInWithPopup(googleProvider);
  }

  Future<void> _signInWithFacebookWeb() async {
    FacebookAuthProvider facebookProvider = FacebookAuthProvider();

    facebookProvider.addScope('email');
    facebookProvider.setCustomParameters({
      'display': 'popup',
    });

    await _firebaseAuth.signInWithPopup(facebookProvider);
  }

  Future<void> _signInWithFacebookNative() async {
    //todo
  }

  Future<UserCredential> _signInWithGoogleNative() async {
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
  }
}
