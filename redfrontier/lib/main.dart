import 'package:flutter/material.dart';
import 'package:redfrontier/screens/welcome_screen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
          titleLarge: TextStyle(
            color: Color(0xFFFF5733), // Mars Red
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(255, 109, 5, 5),
          selectedItemColor: Color(0xFFFF5733),
          unselectedItemColor: Color.fromARGB(255, 198, 195, 195),
          selectedLabelStyle: TextStyle(fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 14),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            foregroundColor: const Color(0xFFB24D4D)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
