import 'package:farmer_consultant/app.dart';
import 'package:farmer_consultant/core/di/global_di.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initGlobalDi();
  runApp(const MyApp());
}
