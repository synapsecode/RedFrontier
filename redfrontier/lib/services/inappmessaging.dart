import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:redfrontier/common/dialogs.dart';

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
}
