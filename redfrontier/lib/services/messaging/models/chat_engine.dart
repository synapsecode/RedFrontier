import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:redfrontier/extensions/extensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/messaging/helpers.dart';
import 'package:redfrontier/services/messaging/messaging.dart';
import 'package:redfrontier/services/messaging/models/chat_entity.dart';
import 'package:uuid/uuid.dart';

class ChatEngine {
  static Future<ChatEntity?> createIndividualChat({
    required RedFrontierUser user,
  }) async {
    if (currentUserIsNull) return null;
    final currentUser = gpc.read(currentRFUserProvider);
    final docID = "${currentUser!.id}-${user.id}";
    final z = [
      await FirebaseFirestore.instance.collection('chats').exists(docID),
      await FirebaseFirestore.instance
          .collection('chats')
          .exists(docID.reverse()),
    ];
    if (z.contains(true)) {
      log('Chat Already Exists');
      final chatID = [docID, docID.reverse()][z.indexOf(true)];
      return await getIndividualChat(chatID);
    } else {
      log('Creating Individual Chat');

      final chatEntity = ChatEntity(
        id: docID,
        type: 'individual',
        name: '${currentUser.name},${user.name}',
        dpMap: {
          currentUser.id.toString():
              "https://i.pinimg.com/736x/dd/f0/11/ddf0110aa19f445687b737679eec9cb2.jpg",
          user.id.toString():
              "https://i.pinimg.com/736x/dd/f0/11/ddf0110aa19f445687b737679eec9cb2.jpg",
        },
        memberIds: [currentUser.id, user.id],
        rawPreviewText: '',
      );
      await FirebaseFirestore.instance.collection('chats').doc(docID).set(
        {
          ...chatEntity.toJson(),
        },
      );
      return await getIndividualChat(docID);
    }
  }

  static createGroupChat(
    List<RedFrontierUser> users,
  ) async {
    if (currentUserIsNull) return null;
    final currentUser = gpc.read(currentRFUserProvider);
    final docID = const Uuid().v1();
    log('Creating Group Chat');

    final chatName =
        [...users.map((x) => x.name).toList(), currentUser!.name].join(',');

    final chatEntity = ChatEntity(
      id: docID,
      type: 'group',
      name: chatName,
      dpMap: {
        '0':
            'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-group-512.png'
      },
      memberIds: [...users.map((x) => x.id).toList(), currentUser.id],
      rawPreviewText: '',
    );
    await FirebaseFirestore.instance.collection('chats').doc(docID).set(
      {
        ...chatEntity.toJson(),
      },
    );
    return await getIndividualChat(docID);
  }

  static Stream<QuerySnapshot<Map<dynamic, dynamic>>> getChatStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .where('members', arrayContains: userId)
        // .fieldContains('members', userId.toString())
        .snapshots();
  }

  static Future<List<ChatEntity>> getChatsByID(List<String> ids) async {
    final x = await FirebaseFirestore.instance
        .collection('chats')
        .where(FieldPath.documentId, whereIn: ids)
        .get();
    List<ChatEntity> chats = [];
    for (final c in x.docs) {
      final chat = ChatEntity.fromMap(c.data());
      chats.add(chat);
    }
    return chats;
  }

  static Future<ChatEntity?> getIndividualChat(String id) async {
    final snap =
        await FirebaseFirestore.instance.collection('chats').doc(id).get();
    final data = snap.data();
    if (data == null) return null;
    return ChatEntity.fromMap(data);
  }

  static updateChat(ChatEntity entity, {bool setActiveChat = true}) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(entity.id)
        .set({...entity.toJson()}, SetOptions(merge: true));
    if (setActiveChat) {
      gpc.read(currentlyActiveChat.notifier).state = entity;
    }
  }

  static deleteChat(ChatEntity entity) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(entity.id)
        .delete();
    gpc.read(currentlyActiveChat.notifier).state = null;
  }

  static bool get currentUserIsNull {
    final u = gpc.read(currentRFUserProvider);
    if (u == null) {
      log('CurrentUser was found to be null');
      return true;
    }
    return false;
  }

  static Future<void> setChatPreview(String id, MessageModel msg) async {
    String preview = msg.text;
    final sender = gpc.read(currentlyActiveChatMembers)?[msg.authorUserID];
    final ts = DateTime.now().millisecondsSinceEpoch;
    if (sender == null) {
      log('Sender is Null; Cannot Register Preview');
      return;
    }
    if (msg.type == 'text') {
      preview = "${sender.name}:${msg.text}:$ts";
    } else if (msg.type == 'sharedpost') {
      preview = "${sender.name}:Sent a Post:$ts";
    } else if (msg.type == 'media') {
      preview = "${sender.name}:Shared a media file:$ts";
    }
    log('Registering ChatPreview => $preview');
    await FirebaseFirestore.instance.collection('chats').doc(id).set(
      {'preview': preview},
      SetOptions(merge: true),
    );
  }
}
