import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudFunctions {
  final String region = 'asia-east1';

  Future<void> signInWithPhone(String phone, FirebaseAuth auth) async {
    final HttpsCallable callable = FirebaseFunctions.instanceFor(region: region)
        .httpsCallable('loginByPhone');

    final HttpsCallableResult result = await callable.call(<String, dynamic>{
      'phoneNumber': phone,
    });
    await auth.signInWithCustomToken(result.data['token']);

    if (auth.currentUser == null) {
      throw '登入失敗';
    }
  }
}
