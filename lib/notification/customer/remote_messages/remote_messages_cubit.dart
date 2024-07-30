import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:house/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'remote_messages_state.dart';

class RemoteMessages extends Cubit<RemoteMessagesState> {
  final List<RemoteMessage> messages = [];

  RemoteMessages() : super(RemoteMessagesInitial());

  void addMessage(RemoteMessage message) async {
    debugPrint('add message: ${message.notification?.title}');
    messages.insert(0, message);  
    await saveMessageToPrefs(message);
    emit(RemoteMessagesLoaded(List.from(messages)));
  }

 

  Future<void> loadMessagesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? storedMessages = prefs.getStringList('messages');
    if (storedMessages != null) {
      final List<RemoteMessage> loadedMessages = storedMessages.map((m) {
        final Map<String, dynamic> data = jsonDecode(m);
        return RemoteMessage(
          notification: RemoteNotification(
            title: data['title'],
            body: data['body'],
          ),
          sentTime: DateTime.parse(data['sentTime']),
        );
      }).toList();
      messages.addAll(loadedMessages);
      emit(RemoteMessagesLoaded(List.from(messages)));
      debugPrint('loaded messages: ${messages.length}');
    }
  }
}
