import 'package:firebase_auth/firebase_auth.dart';
Future<T> handleAuthErrors<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on FirebaseAuthException catch (e) {
    throw AuthErrorTranslator.tw(e);
  } catch (e) {
    throw Exception('Unexpected error: $e');
  }
}

class AuthErrorTranslator {
  static String tw(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
        return '無效帳號或密碼';
      case 'email-already-in-use':
        return '此信箱已被使用';
      case 'weak-password':
        return '密碼強度不足';
      case 'operation-not-allowed':
        return '此操作未被允許';
      case 'missing-password':
        return '請輸入密碼';
      case 'invalid-email':
        return '無效的信箱';
      case 'user-disabled':
        return '此使用者已被停用';
      case 'wrong-password':
        return '密碼錯誤';
      case 'invalid-verification-code':
        return '無效的驗證碼';
      case 'invalid-verification-id':
        return '無效的驗證碼';
      case 'missing-continue-uri':
        return '請提供繼續網址';
      case 'user-not-found':
        return '找不到此使用者';
      case 'missing-android-pkg-name':
        return '必須提供 Android 包名稱';
      case 'missing-ios-bundle-id':
        return '必須提供 iOS Bundle ID';
      case 'invalid-continue-uri':
        return '提供的繼續網址無效';
      case 'unauthorized-continue-uri':
        return '繼續網址的域名未列入白名單。請在 Firebase 控制台中將域名列入白名單。';
 
      default:
        return e.code;
    }
  }
}
