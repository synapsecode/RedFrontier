import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RedFrontierUser {
  final String id;
  final String email;
  final String? dp;

  String get name => email.split('@').first;

  factory RedFrontierUser.fromFBUser(User u) {
    return RedFrontierUser(
      id: u.uid,
      email: u.email!,
    );
  }

  factory RedFrontierUser.fromMap(Map u) {
    return RedFrontierUser(
      id: u['uid'],
      email: u['email'],
      dp: u['dp'],
    );
  }

  RedFrontierUser({
    required this.id,
    required this.email,
    this.dp,
  });
}

final currentRFUserProvider = StateProvider<RedFrontierUser?>((ref) => null);
