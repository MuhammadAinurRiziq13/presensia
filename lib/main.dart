import 'package:flutter/material.dart';
<<<<<<< HEAD
// Import login.dart
import 'splash_screen.dart'; // Import splash_screen.dart
=======
import 'pages/login/login.dart'; // Import login.dart
import 'pages/splash_screen/splash_screen.dart'; // Import splash_screen.dart
>>>>>>> 773626dfa1f1dd7b4613bc9bdb4f39a3b977c834

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
      home: const SplashScreen(), // Tampilkan SplashScreen terlebih dahulu
    );
  }
}
