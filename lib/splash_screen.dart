import 'package:flutter/material.dart';
import 'dart:async'; // Import untuk Future.delayed
import 'login.dart'; // Import login.dart untuk navigasi ke halaman login

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay 1 detik sebelum berpindah ke LoginPage
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/logo.png', // Path gambar logo
          width: 150.0, // Sesuaikan ukuran logo
          height: 150.0,
        ),
      ),
    );
  }
}
