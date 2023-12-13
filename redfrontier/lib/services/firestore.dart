import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redfrontier/common/dialogs.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/models/redfrontier_user.dart';

class FirestoreService {
  static final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  static createUser(RedFrontierUser user, String dp) async {
    try {
      await usersCollection.doc(user.id).set({
        'email': user.email,
        'dp': dp,
        'uid': user.id,
      });
      print('User created successfully');
    } catch (e) {
      print('Error creating user: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'UserCreation Error',
        contentText: '$e',
      );
    }
  }

  static Future<List<RedFrontierUser>> searchUserByEmail(String email) async {
    List<RedFrontierUser> users = [];
    try {
      QuerySnapshot querySnapshot = await usersCollection
          .where('email', isGreaterThanOrEqualTo: email)
          .where('email', isLessThan: '${email}z')
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final u = RedFrontierUser.fromMap({
          'uid': doc['uid'],
          'email': doc['email'],
          'dp': doc['dp'],
        });
        users.add(u);
      }
    } catch (e) {
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'SearchUser Error',
        contentText: '$e',
      );
    }
    return users;
  }

  static Future<RedFrontierUser?> fetchUserByID(String id) async {
    try {
      final docSnapshot = await usersCollection.doc(id).get();
      if (docSnapshot.exists) {
        var d = docSnapshot.data() as Map?;
        if (d == null) return null;
        final u = RedFrontierUser.fromMap({
          'uid': d['uid'],
          'email': d['email'],
          'dp': d['dp'],
        });
        return u;
      }
    } catch (e) {
      print('Error reading users: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'UserRead Error',
        contentText: '$e',
      );
    }
  }

  static Future<List<RedFrontierUser>> fetchAllUsers() async {
    List<RedFrontierUser> users = [];
    try {
      QuerySnapshot querySnapshot = await usersCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final u = RedFrontierUser.fromMap({
          'uid': doc['uid'],
          'email': doc['email'],
          'dp': doc['dp'],
        });
        users.add(u);
      }
    } catch (e) {
      print('Error reading users: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'UserRead Error',
        contentText: '$e',
      );
    }
    return users;
  }

  static Future<List<RedFrontierUser>> fetchUsersByIDList(
    List<String> ids,
  ) async {
    List<RedFrontierUser> users = [];
    try {
      QuerySnapshot querySnapshot =
          await usersCollection.where(FieldPath.documentId, whereIn: ids).get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final u = RedFrontierUser.fromMap({
          'uid': doc['uid'],
          'email': doc['email'],
          'dp': doc['dp'],
        });
        users.add(u);
      }
    } catch (e) {
      print('Error reading users: $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'UserRead Error',
        contentText: '$e',
      );
    }
    return users;
  }

  // Update data in Firestore
  static Future<void> updateUserDP(RedFrontierUser user, String newDp) async {
    try {
      await usersCollection.doc(user.id).update({
        'dp': newDp,
      });
      print('UseDPr updated successfully');
    } catch (e) {
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentTitle: 'UserDPUpdate Error',
        contentText: '$e',
      );
    }
  }

  // Delete data from Firestore
  static Future<void> deleteUser(RedFrontierUser user) async {
    try {
      await usersCollection.doc(user.id).delete();
      print('User deleted successfully');
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}
