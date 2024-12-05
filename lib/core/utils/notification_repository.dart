import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Menyiapkan plugin notifikasi lokal
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationRepository {
  static final AndroidNotificationChannel channel =
      const AndroidNotificationChannel(
    'default_channel', // Channel ID
    'Default Channel', // Channel Name
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  // Fungsi untuk menginisialisasi notifikasi
  static Future<void> initializeNotifications(BuildContext context) async {
    // Membuat notification channel untuk Android
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Inisialisasi pengaturan untuk Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Kombinasikan dengan pengaturan lainnya
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    // Inisialisasi plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // Menangani respons notifikasi jika diterima
        if (details.payload != null) {
          print('Payload: ${details.payload}');
          // Bisa ditambahkan logika untuk membuka halaman tertentu
        }
      },
    );
  }

  // Fungsi untuk menampilkan notifikasi
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Used for general notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0, // ID notifikasi (bisa diubah)
      title, // Judul notifikasi
      body, // Isi pesan notifikasi
      platformDetails, // Detil platform (android)
    );
  }
}
