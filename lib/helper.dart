import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
Page getPage({
  required Widget child,
  required GoRouterState state,
}) {
  return MaterialPage(
    key: state.pageKey,
    child: child,
  );
}

//timestamp to date

DateTime? timestampToDate(Map<String, dynamic> map, String key) {
  return map[key] != null ? (map[key] as Timestamp).toDate() : null;
}

Timestamp? dateToTimestamp(DateTime? date) {
  return date != null ? Timestamp.fromDate(date) : null;
}

//extendsion fieldvalue to date

enum ServerTimeStamp { yes, no }
 
 
Future<void> clearPreferences() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

  Future<void> saveMessageToPrefs(RemoteMessage message) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedMessages = prefs.getStringList('messages');
    final List<Map<String, dynamic>> messageList = storedMessages != null
        ? storedMessages.map((m) => jsonDecode(m) as Map<String, dynamic>).toList()
        : [];

    final messageData = {
      'title': message.notification?.title,
      'body': message.notification?.body,
      'sentTime': message.sentTime?.toIso8601String(),
    };

    messageList.insert(0, messageData);  // 新消息插入到列表开头

    final encodedMessages = messageList.map((m) => jsonEncode(m)).toList();
    await prefs.setStringList('messages', encodedMessages);
  }