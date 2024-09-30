import 'package:flutter/material.dart';
import 'pages/login/login.dart'; // Import login.dart
import 'pages/splash_screen/splash_screen.dart'; // Import splash_screen.dart

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
