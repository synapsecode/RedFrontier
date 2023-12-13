import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';

final currentlyActiveChat = StateProvider<ChatEntity?>((ref) => null);

class ChatEntity {
  final String id;
  final String type;
  String name;
  Map dpMap;
  String rawPreviewText;
  List memberIds;

  ChatEntity({
    required this.id,
    required this.type,
    required this.name,
    required this.dpMap,
    required this.memberIds,
    required this.rawPreviewText,
  });

  //ACTION: Muting is just removing your deviceToken

  ChatPreviewEntity get preview {
    return ChatPreviewEntity.fromPreviewString(this);
  }

  String get chatName {
    if (type == 'group') {
      return name;
    } else {
      //Get CurrentUser Name
      final cu = gpc.read(currentRFUserProvider);
      if (cu == null) {
        print('CurrentUser was found to be null');
        return name;
      }
      //Remove CurrentUser name from joined name
      final cuName = cu.name.split('@').first;
      String cn = name
          .replaceAll(',$cuName', '')
          .replaceAll('$cuName,', '')
          .replaceAll(cuName, '');
      return cn.trim();
    }
  }

  factory ChatEntity.fromMap(Map x) {
    return ChatEntity(
      id: x['id'].toString(),
      type: x['type'],
      name: x['name'],
      dpMap: x['dp'],
      memberIds: x['members'],
      rawPreviewText: x['preview'] ?? '',
    );
  }

  Map toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'dp': dpMap,
      'members': memberIds,
    };
  }

  String get chatDP {
    if (dpMap.isEmpty) {
      //Warning Sign shown when dpMap is empty
      return 'https://img.icons8.com/color/48/null/error--v4.png';
    }
    if (type == 'group') {
      //for groups, the value is always the value of the first key(0)
      if (dpMap['dp'] == null) {
        return 'https://img.icons8.com/color/48/null/error--v4.png';
      }
      return (dpMap['dp']);
    } else {
      //Get CurrentUser Name
      final cu = gpc.read(currentRFUserProvider);
      if (cu == null) {
        print('CurrentUser was found to be null');
        return 'https://img.icons8.com/ios-filled/50/null/user-not-found.png';
      }
      final idlist = dpMap.keys.where((e) => e != cu.name.toString()).toList();
      if (idlist.length != 1) {
        return 'https://img.icons8.com/glyph-neue/64/null/no-user.png';
      }
      String id = idlist.first.toString();
      String dp = dpMap[id].toString().trim();
      if (dp == "null") {
        return 'https://img.icons8.com/glyph-neue/64/null/no-user.png';
      }

      return dp;
    }
  }
}

class ChatPreviewEntity {
  final String preview;
  final String? senderName;
  final String timestamp;

  ChatPreviewEntity({
    required this.preview,
    required this.senderName,
    required this.timestamp,
  });

  factory ChatPreviewEntity.fromPreviewString(ChatEntity c) {
    final p = c.rawPreviewText;
    final parts = p.split(':');
    if (p.isEmpty || parts.length != 3) {
      return ChatPreviewEntity(
        preview: 'Click here to start chatting',
        senderName: '',
        timestamp: '',
      );
    }

    final dt = DateTime.fromMillisecondsSinceEpoch(int.parse(parts[2]));
    final dtx = DateFormat('hh:mm a').format(dt);

    String? sender = parts[0].trim();

    if (c.type == 'individual') {
      sender = null;
    } else {
      final u = gpc.read(currentRFUserProvider)!;
      if (sender == u.name.trim()) {
        sender = null;
      }
    }

    return ChatPreviewEntity(
      senderName: sender,
      preview: parts[1].trim(),
      timestamp: dtx,
    );
  }
}
