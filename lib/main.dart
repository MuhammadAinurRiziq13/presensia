import 'package:flutter/material.dart';
import 'login.dart'; // Import login.dart
import 'splash_screen.dart'; // Import splash_screen.dart

void main() {
  runApp(const MyApp());
}

// test
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
