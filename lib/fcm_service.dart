import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:house/helper/const.dart';
import 'package:house/main.dart';
 

class FcmService {
  FcmService._privateConstructor();

  static final FcmService _instance = FcmService._privateConstructor();

  factory FcmService() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static Function(RemoteMessage)? onMessageCallback;
  static Function(RemoteMessage)? onBackgroundMessageCallback;

  Future<void> initialize() async {
    getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('onMessage: $message');
      onMessageCallback?.call(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> saveFcmToken(String token) async {
    if (auth.currentUser != null) {
      await store.collection('userRoles').doc(auth.currentUser!.uid).update({
        'fcmToken': token,
      });
    }
  }

  void setOnMessageCallback(Function(RemoteMessage) callback) {
    onMessageCallback = callback;
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint('Handling a background message: ${message.messageId}');
    onBackgroundMessageCallback?.call(message);
 
  }

  Future<void> getToken() async {
    String? token = await _firebaseMessaging.getToken(vapidKey: Const.vapidKey);
    if (token != null) {
      debugPrint('FCM Token: $token');
      await saveFcmToken(token);
    }
  }
}
