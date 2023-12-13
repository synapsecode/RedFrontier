import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/messaging/messaging.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';
import 'package:uuid/uuid.dart';

class MessageTextBox extends StatelessWidget {
  final TextEditingController controller;
  const MessageTextBox({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CupertinoTextField(
        textAlignVertical: TextAlignVertical.center,
        placeholder: 'type message...',
        controller: controller,
        maxLines: null,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        placeholderStyle: const TextStyle(fontSize: 20, color: Colors.white30),
        style: const TextStyle(fontSize: 20, color: Colors.white),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
      ).clip(8).limitSize(null, 50),
    );
  }
}

class SendMessageCircularButton extends StatelessWidget {
  final ChatEntity chatModel;
  final Function setState;
  final TextEditingController controller;
  final ScrollController scrollController;
  final BuildContext originalContext;
  const SendMessageCircularButton({
    Key? key,
    required this.setState,
    required this.chatModel,
    required this.controller,
    required this.scrollController,
    required this.originalContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      child: Icons.send_rounded.toIcon().addLeftMargin(3),
    ).onClick(() async {
      String msg = controller.value.text;
      FocusScope.of(originalContext).requestFocus(FocusNode());
      controller.clear();
      setState(() {});
      final cu = gpc.read(currentRFUserProvider);
      // ----------------- Prevent empty message ------------------
      if (msg.isEmpty) return;
      // ----------------------------------------------------------

      log('SENDING MESSAGE');
      await MessageEngine.createMessage(
        chatModel.id,
        MessageModel(
          id: const Uuid().v1(),
          text: msg,
          timestamp: DateTime.now().millisecondsSinceEpoch,
          authorUserID: cu!.id,
          type: 'text',
        ),
      );

      setState(() {});
    });
  }
}
