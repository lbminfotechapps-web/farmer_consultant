import 'package:farmer_consultant/app.dart';
import 'package:farmer_consultant/core/di/global_di.dart';
import 'package:farmer_consultant/core/localization/language_provider.dart';
import 'package:farmer_consultant/core/notification/fcm_service.dart';
import 'package:farmer_consultant/core/notification/firebase_background_handler.dart';
import 'package:farmer_consultant/core/notification/local_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseReady = false;

  try {
    // 1. Initialize Firebase
    await Firebase.initializeApp();

    firebaseReady = true;

    debugPrint('FIREBASE INITIALIZED SUCCESSFULLY');

    // 2. Register background FCM handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    debugPrint('FCM BACKGROUND HANDLER REGISTERED');
  } catch (error) {
    debugPrint('FIREBASE INITIALIZATION ERROR: $error');
  }

  // 3. Initialize dependency injection
  await initGlobalDi();

  // 4. Initialize notification services
  if (firebaseReady) {
    await LocalNotificationService.instance.initialize();

    await FcmService.instance.initialize();

    debugPrint('FCM SERVICES INITIALIZED');
  }

    // 5. Initialize Global Language Provider
  final languageProvider = LanguageProvider();
   await languageProvider.loadLanguage();

     debugPrint(
    'CURRENT LANGUAGE: ${languageProvider.currentLanguageCode}',
  );


  // 5. Start application
  runApp( MyApp(languageProvider: languageProvider));
}
