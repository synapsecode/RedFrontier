import 'package:flutter/material.dart';
import 'package:redfrontier/screens/welcome_screen.dart';

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
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 149, 13, 13)),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
