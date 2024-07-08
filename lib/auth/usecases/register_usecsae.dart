import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// - [注册流程 - 第一步](file://./../diagrams/register_1_phone_flow.wsd)
/// - [注册流程 - 第二步](file://./../diagrams/register_2_password_flow.wsd)

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
      if (e.code == 'email-already-in-use') {
        throw '此信箱已被使用';
      } else if (e.code == 'weak-password') {
        throw '密碼強度不足';
      } else if (e.code == 'operation-not-allowed') {
        throw '此操作未被允許';
      } else if (e.code == 'missing-password') {
        throw '請輸入密碼';
      } else if (e.code == 'invalid-email') {
        throw '無效的信箱';
      } else {
        throw e.code;
      }
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
