import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redfrontier/extensions/common/dialogs.dart';
import 'package:redfrontier/extensions/navextensions.dart';
import 'package:redfrontier/main.dart';
import 'package:redfrontier/screens/home_page.dart';
import 'package:redfrontier/screens/login_screen.dart';

class FirebaseAuthService {
  static signInWithEmail(String email, String password) async {
    try {
      final uc = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Exception:signInWithEmail => $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentText: '$e',
        contentTitle: 'SignUp Exception',
      );
    }
  }

  static loginWithEmail(String email, String password) async {
    try {
      final uc = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Exception:signInWithEmail => $e');
      CustomDialogs.showDefaultAlertDialog(
        navigatorKey.currentState!.context,
        contentText: '$e',
        contentTitle: 'Login Exception',
      );
    }
  }

  static logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static handleAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((e) {
      if (e != null) {
        Navigator.of(navigatorKey.currentState!.context)
            .replaceWithNewPage(HomePage());
      } else {
        Navigator.of(navigatorKey.currentState!.context)
            .replaceWithNewPage(LoginScreen());
      }
    });
  }
}
