import 'package:flutter/material.dart';
// Import login.dart
import 'package:presensia/pages/splash_screen/splash_screen.dart'; // Import splash_screen.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Presensia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(), 
    );
  }
}
