import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/constants.dart';

class InAppMessagingService {
  String? deviceToken;

  static initialize() async {
    FirebaseMessaging.instance.getInitialMessage().then((value) {});
    final token = await FirebaseMessaging.instance.getToken();
    print('InAppMessaging DeviceToken: $token');
  }

  static startListening(BuildContext context) {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message == null) return;
      print("onMessage: $message");
      // Display the message or perform any action
      CustomDialogs.showDefaultAlertDialog(
        context,
        contentTitle: 'SOS Alert',
        contentText: message?.notification?.body ?? "",
      );
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
      // Display the message or perform any action
      CustomDialogs.showDefaultAlertDialog(
        context,
        contentTitle: 'SOS Alert',
        contentText: message?.notification?.body ?? "",
      );
    });
  }

  static Future<void> broadcastMessage({
    required String title,
    required String message,
  }) async {
    const fcmUrl =
        'https://fcm.googleapis.com/v1/projects/redfrontier/messages:send';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${ProjectConstants.fcmServerKey}',
    };
    final notification = {
      'title': title,
      'body': message,
    };
    final Map<String, dynamic> data = {
      'message': {'notification': notification},
      'topic': 'allDevices',
    };

    final response = await http.post(
      Uri.parse(fcmUrl),
      headers: headers,
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
    } else {
      print('Failed to send notification. Status code: ${response.statusCode}');
    }
  }
}
