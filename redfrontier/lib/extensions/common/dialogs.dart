import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/extensions.dart';

class CustomDialogs {
  static Future<T?> showDefaultAlertDialog<T>(
    BuildContext context, {
    String? contentText,
    String? contentTitle,
  }) async {
    print('ERROR OCCURED');
    return await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(contentTitle ?? '').color(Colors.black),
          content: Text(contentText ?? '').color(Colors.black),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
