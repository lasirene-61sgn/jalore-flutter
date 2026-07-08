import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/theme.dart';
import 'package:flutter_app/firebase_options.dart';
import 'package:flutter_app/services/local_storage/shared_preference.dart';
import 'package:flutter_app/services/network_service/network_error_screen.dart';
import 'package:flutter_app/services/network_service/network_notifier.dart';
import 'package:flutter_app/services/routes/route_name/route_name.dart';
import 'package:flutter_app/services/routes/route_page/route_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'services/api/notification_service/notifiction_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (defaultTargetPlatform == TargetPlatform.iOS) return;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Handle Firebase initialization safely
  if (defaultTargetPlatform != TargetPlatform.iOS) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    } catch (e) {
      debugPrint("Firebase initialization failed: $e");
    }
  }

  // Initialize your notification service
  await NotificationService.init();
  await SharedPreferencesHelper().init();
  String? deviceToken = await NotificationService.getToken();
  if(deviceToken != null){
    print("--------- DEVICE TOKEN ---------");
    print(deviceToken);
    SharedPreferencesHelper().setString("DToken",deviceToken);
    print("--------------------------------");
  }else{
    print("Device token is null");
  }


  if (defaultTargetPlatform != TargetPlatform.iOS) {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("App launched from terminated state via notification");
      // You can handle redirection logic here or inside NotificationService
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(networkStatusProvider);

    final isConnected = isConnectedAsync.maybeWhen(
      data: (value) => value,
      orElse: () => true,
    );

    return GetMaterialApp(
      title: 'SSJSC',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      builder: (context, child) {

        return Stack(
          children: [
            child!,
            if (!isConnected)
              const NetworkOverlay()
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}