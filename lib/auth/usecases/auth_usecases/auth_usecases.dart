import 'package:firebase_auth/firebase_auth.dart';
import 'native_auth_usecases.dart';
import 'web_auth_usecases.dart';

///shortcuts for child usecases
///[NativeAuthUsecases]
///[WebAuthUsecases]

abstract class AuthUsecases {
  FirebaseAuth get firebaseAuth;

  //登入
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  //第三方登入
  Future<UserCredential> signInWithGoogle();
  Future<void> signInWithFacebook();

  //註冊
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  //簡訊登入
  Future<dynamic> sendSmsCode({required String phoneNo});

  Future<void> confirmSmsCode({
    required String smsCode,
    String? verificationId, // native
    ConfirmationResult? confirmationResult, // web
  });

  //其他
  Future<void> forgetPassword(String email);
}
