import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/main.dart';
import 'package:uuid/uuid.dart';

final latestMessageProvider = StateProvider<MessageModel?>((ref) => null);

class MessageModel {
  final String id;
  final String type;
  final String text;
  final int timestamp;
  final String authorUserID;

  MessageModel({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.authorUserID,
    required this.type,
  });

  factory MessageModel.fromMap(Map x) {
    return MessageModel(
      id: x['id'].toString(),
      type: x['type'],
      text: x['text'],
      timestamp: x['timestamp'],
      authorUserID: x['author_user_id'],
    );
  }

  Map toJson() {
    return {
      'id': id,
      'type': type,
      'text': text,
      'timestamp': timestamp,
      'author_user_id': authorUserID,
    };
  }
}

class MessageEngine {
  static createMessage(String chatID, MessageModel msg) async {
    gpc.read(latestMessageProvider.notifier).state = msg;
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .doc(const Uuid().v1())
        .set({
      ...msg.toJson(),
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessageStream(
      {required String chatId}) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  static editMessage(String chatID, MessageModel msg) async {
    return await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .doc(const Uuid().v1())
        .set(
      {
        ...msg.toJson(),
      },
      SetOptions(merge: true),
    );
  }

  static deleteMessage(String chatID, MessageModel msg) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatID)
        .collection('messages')
        .doc(msg.id)
        .delete();
  }
}
