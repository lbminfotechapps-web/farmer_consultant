import 'dart:async';

import 'package:farmer_consultant/core/notification/notification_navigation_service.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/utility/appname.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _navigationTimer;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();

    _navigationTimer = Timer(const Duration(seconds: 2), _checkLogin);
  }

  Future<void> _checkLogin() async {
    final String farmerId = await SecureStorage.instance.getFarmerId();

    if (!mounted) return;

    NotificationNavigationService.instance.completeAuthentication(
      router: GoRouter.of(context),
      farmerId: farmerId,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: context.primaryColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: context.appColors.shadow.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                  image: const DecorationImage(
                    image: AssetImage('assets/icons/logo.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                appName,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: context.onPrimaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Loading your workspace...',
                style: TextStyle(
                  fontSize: 16,
                  color: context.onPrimaryColor.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: 180,
                child: LinearProgressIndicator(
                  backgroundColor: context.onPrimaryColor.withValues(
                    alpha: 0.24,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.onPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
