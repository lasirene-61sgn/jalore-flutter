import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _messaging = FirebaseMessaging.instance;
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  // Define the High Importance Channel for Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  static Future<void> init() async {
    // 1. Request Permissions (Crucial for Android 13+)
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    // 2. Initialize Local Notifications
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(), // Added for iOS support
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle what happens when user taps a LOCAL notification
        print("Local notification tapped: ${details.payload}");
      },
    );

    // 3. Create the Android Channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    // 4. Set Foreground Presentation Options
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (defaultTargetPlatform != TargetPlatform.iOS) {
      _setupMessageHandlers();
    }
  }

  static void _setupMessageHandlers() {
    // STATE: FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
          payload: message.data.toString(),
        );
      }
    });

    // STATE: BACKGROUND (App minimized, user taps notification)
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("App opened from background: ${message.data}");
      // Navigate to specific screen here if needed
    });

    // STATE: TERMINATED (App closed, user taps notification)
    _messaging.getInitialMessage().then((message) {
      if (message != null) {
        print("App opened from terminated state: ${message.data}");
        // Navigate based on message data
      }
    });
  }

  static Future<String?> getToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) return null;
    return await _messaging.getToken();
  }
}