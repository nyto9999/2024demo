import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:house/helper/const.dart';
import 'package:house/main.dart';

class FcmService {
  FcmService._privateConstructor();

  static final FcmService _instance = FcmService._privateConstructor();

  factory FcmService() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    getToken();

    // 設置前台消息處理
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
  }

  Future<void> saveFcmToken(String token) async {
    if (auth.currentUser != null) {
      await store.collection('userRoles').doc(auth.currentUser!.uid).update({
        'fcmToken': token,
      });
    }
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // AndroidNotification? android = message.notification?.android;

    print('Notification Title: ${notification?.title}');
  }

  getToken() async {
    String? token = await _firebaseMessaging.getToken(vapidKey: Const.vapidKey);
    if (token != null) {
      debugPrint('FCM Token: $token');
      await saveFcmToken(token);
    }
  }

  Future<void> sendPushMessage() async {
    const token =
        'cDjEgVulk6EkjdBPP-_a9W:APA91bHTd4kxXpo8lmdBBH2tXfzGT6Noy7RAnjVD0DwPzF64xG__MH2nkF5z9uukl2R5_u-VpjJBQaTAaz4dlDCH_-0EBPvqGBeDWFSTMBQgwpXIHg3Rg65VFGlPjYt3hy1BEjFnBkfT';

    try {
      await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/${Const.projectId}/messages:send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=${Const.vapidKey}',
        },
        body: constructFCMPayload(token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  /// The API endpoint here accepts a raw FCM payload for demonstration purposes.
  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification (#) was created via FCM!',
      },
    });
  }
}
