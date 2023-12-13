import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';
import 'package:redfrontier/services/firestore.dart';

extension FirebaseCollectionHelpers on CollectionReference {
  Future<bool> exists(String id) async {
    final snapshot = await doc(id.toString()).get();
    return snapshot.exists;
  }

  Query<Map> fieldContains(String fieldName, String query) {
    return where(fieldName, isGreaterThanOrEqualTo: query)
        .where(fieldName, isLessThan: '${query}z') as Query<Map>;
  }
}

final currentlyActiveChatMembers =
    StateProvider<Map<String, RedFrontierUser>?>((ref) => null);

class ChatHelpers {
  static setCurrentlyActiveChatMembers(List memberIds) async {
    Map<String, RedFrontierUser> members = {};
    for (final mid in memberIds) {
      final u = await FirestoreService.fetchUserByID(mid);
      if (u == null) continue;
      members[mid] = u;
    }
    gpc.read(currentlyActiveChatMembers.notifier).state = members;
  }
}
