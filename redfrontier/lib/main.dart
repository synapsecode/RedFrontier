import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redfrontier/extensions/miscextensions.dart';
import 'package:redfrontier/extensions/navextensions.dart';
import 'package:redfrontier/screens/home_page.dart';
import 'package:redfrontier/screens/login_screen.dart';
import 'package:redfrontier/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redfrontier/services/auth/firebase_auth.dart';
import 'package:redfrontier/services/inappmessaging.dart';

final gpc = ProviderContainer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(androidProvider: AndroidProvider.debug);
  await InAppMessagingService.initialize();

  runApp(
    UncontrolledProviderScope(
      container: gpc,
      child: const RedFrontierApp(),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class RedFrontierApp extends StatelessWidget {
  const RedFrontierApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primaryColor: const Color(0xFFFF5733),
          scaffoldBackgroundColor: const Color(0xFF330000),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 149, 13, 13)),
          textTheme: TextTheme(
            displayLarge: GoogleFonts.orbitron(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFB24D4D)),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color.fromARGB(255, 109, 5, 5),
            selectedItemColor: Color(0xFFFF5733),
            unselectedItemColor: Color.fromARGB(255, 198, 195, 195),
            selectedLabelStyle: TextStyle(fontSize: 14),
            unselectedLabelStyle: TextStyle(fontSize: 14),
          ),
          useMaterial3: true,
        ),
        home: const RedFrontierWrapper(),
      ),
    );
  }
}

class RedFrontierWrapper extends StatefulWidget {
  const RedFrontierWrapper({super.key});

  @override
  State<RedFrontierWrapper> createState() => _RedFrontierWrapperState();
}

class _RedFrontierWrapperState extends State<RedFrontierWrapper> {
  @override
  void initState() {
    FirebaseAuthService.handleAuthChanges();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator().center();
  }
}
