import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/miscextensions.dart';
import 'package:redfrontier/extensions/navextensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/screens/chat/individual_chat/individual_chat.dart';
import 'package:redfrontier/services/messaging/helpers.dart';
import 'package:redfrontier/services/messaging/models/chat_engine.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';

class ChatLoader extends StatefulWidget {
  final String chatID;
  const ChatLoader({Key? key, required this.chatID}) : super(key: key);

  @override
  State<ChatLoader> createState() => _ChatLoaderState();
}

class _ChatLoaderState extends State<ChatLoader> {
  initialize() async {
    final chatEntity = await ChatEngine.getIndividualChat(widget.chatID);
    if (chatEntity == null) {
      log('ChatEntity does not exist');
      Navigator.of(context).pop();
      return;
    }
    gpc.read(currentlyActiveChat.notifier).state = chatEntity;
    await ChatHelpers.setCurrentlyActiveChatMembers(
      chatEntity.memberIds,
    );
    Navigator.of(context).replaceWithNewPage(const IndividualChat());
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CircularProgressIndicator().center(),
    );
  }
}
