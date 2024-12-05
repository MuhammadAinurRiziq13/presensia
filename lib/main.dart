import 'package:flutter/material.dart';
import 'package:presensia/core/config/routes.dart';
import 'package:intl/intl.dart'; // To format dates
import 'package:intl/date_symbol_data_local.dart'; // Import this for initializeDateFormatting
import 'core/utils/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initBackgroundService();

  // Initialize the date formatting for 'id_ID' locale
  await initializeDateFormatting(
      'id_ID', null); // Initialize Indonesian date format

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
      title: 'Presensia',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
