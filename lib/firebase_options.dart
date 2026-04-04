import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) throw UnsupportedError('Web not configured');
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError('iOS not configured');
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDv3LBRo2VqjldjEXDR1d7F40YDhkqGKsc', // Found in google-services.json -> current_key
    appId: '1:992878145244:android:e1e72a279f1f74b84bce19',   // Found in google-services.json -> mobilesdk_app_id
    messagingSenderId: '992878145244', // Found in google-services.json -> project_number
    projectId: 'jalore-d7dc0',       // Found in google-services.json -> project_id
    storageBucket: 'jalore-d7dc0.firebasestorage.app',
  );
}