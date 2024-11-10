import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presensia/presentation/screens/splash_screen/splash_screen.dart';
import 'core/config/routes.dart';

void main() async {
  // Pastikan Flutter telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Menangkap error global (opsional)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  // Memeriksa apakah pengguna sudah login (opsional)
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  // Tentukan initialRoute berdasarkan token
  String initialRoute = token != null ? '/home' : '/';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Presensia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute, // Gunakan initialRoute yang ditentukan
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
