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
        primaryColor: Color(0xFFFF5733),
        scaffoldBackgroundColor: Color(0xFF330000),
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 149, 13, 13)),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.orbitron(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFFB24D4D)),
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
