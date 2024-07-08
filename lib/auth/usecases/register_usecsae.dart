import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:house/auth/usecases/firebase_auth_error_translator.dart';

/// - [注册流程 - 第一步](file://./../diagrams/email_register_form_flow.wsd)

//這邊的signIn 都是發送驗證碼
//sendSms 確認之後才會真正SignIn
class RegisterUsecases {
  final FirebaseAuth _firebaseAuth;

  RegisterUsecases({
    required FirebaseAuth auth,
  }) : _firebaseAuth = auth;

  Future<UserCredential > createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
     final credential =  await _firebaseAuth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
       throw AuthErrorTranslator.tw(e);
    }
  }

  Future<ConfirmationResult> signInWithPhoneNumberWeb({
    required String phoneNo,
  }) async {
    final prefix = '+886${phoneNo.substring(1)}';
    return await _firebaseAuth.signInWithPhoneNumber(prefix);
  }

  Future<String> verifyPhoneNumberNative({
    required String phoneNo,
  }) async {
    final prefix = '+886${phoneNo.substring(1)}';

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: prefix,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        throw '驗證失敗';
      },
      codeSent: (String verificationId, int? resendToken) => verificationId,
      codeAutoRetrievalTimeout: (String verificationId) {
        throw '驗證逾時';
      },
    );

    throw '未知錯誤';
  }

  //Web only : send smsCode
  Future<void> confirmSmsCodeWeb({
    required BuildContext context,
    required String smsCode,
    ConfirmationResult? confirmationResult,
  }) async {
    await confirmationResult?.confirm(smsCode);
  }

  Future<void> confirmSmsCodeNative({
    required String smsCode,
    required String verificationId,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await _firebaseAuth.signInWithCredential(credential);
  }
}
