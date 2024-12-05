import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level function for onStart
void onStart(ServiceInstance serviceInstance) {
  backgroundTask(serviceInstance);
}

void backgroundTask(ServiceInstance serviceInstance) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const androidDetails = AndroidNotificationDetails(
    'default_channel',
    'Default Channel',
    importance: Importance.max,
    priority: Priority.high,
  );
  const platformDetails = NotificationDetails(android: androidDetails);

  flutterLocalNotificationsPlugin.show(
    0,
    'Background Task',
    'This is a background notification!',
    platformDetails,
  );
}

void initBackgroundService() {
  final service = FlutterBackgroundService();

  service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart, // Now onStart is a top-level function
      autoStart: true,
      isForegroundMode:
          true, // Ensure it's in foreground mode for background tasks
    ),
    iosConfiguration: IosConfiguration(),
  );

  service.startService(); // Start the service
}
