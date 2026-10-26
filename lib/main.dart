import 'package:farmer_consultant/app.dart';
import 'package:farmer_consultant/core/di/global_di.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (error) {
    // Notifications are optional; missing platform configuration must not
    // prevent users from opening the app and signing in.
    debugPrint('Firebase unavailable; push notifications disabled: $error');
  }

  await initGlobalDi();
  runApp(const MyApp());
}
