import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FcmTokenService {
  FcmTokenService._();

  static final FcmTokenService instance = FcmTokenService._();

  FirebaseMessaging get _messaging => FirebaseMessaging.instance;

  String? _currentToken;

  StreamSubscription<String>? _tokenRefreshSubscription;
  bool get _isAvailable =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) &&
      Firebase.apps.any((app) => app.name == '[DEFAULT]');

  // ============================================================
  // GET FCM TOKEN
  // ============================================================

  Future<String?> getFcmToken() async {
    try {
      if (!_isAvailable) {
        debugPrint(
          'FCM unavailable: Firebase is not initialized or this platform is unsupported.',
        );
        return null;
      }
      // ========================================================
      // REQUEST PERMISSION
      // ========================================================

      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint(
        'NOTIFICATION STATUS: '
        '${settings.authorizationStatus}',
      );

      if (Platform.isIOS &&
          settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        debugPrint('Notification permission not granted');

        return null;
      }

      // ========================================================
      // IOS - WAIT FOR APNS TOKEN
      // ========================================================

      if (Platform.isIOS) {
        String? apnsToken;

        for (int attempt = 1; attempt <= 15; attempt++) {
          try {
            apnsToken = await _messaging.getAPNSToken();
          } catch (e) {
            debugPrint('APNS TOKEN ERROR: $e');
          }

          if (apnsToken != null && apnsToken.trim().isNotEmpty) {
            debugPrint('======================================');

            debugPrint('APNS TOKEN AVAILABLE');

            debugPrint(apnsToken);

            debugPrint('======================================');

            break;
          }

          debugPrint(
            'Waiting for APNS token '
            '$attempt/15',
          );

          await Future.delayed(const Duration(seconds: 1));
        }

        if (apnsToken == null || apnsToken.trim().isEmpty) {
          debugPrint('APNS TOKEN NOT AVAILABLE');

          return null;
        }
      }

      // ========================================================
      // GET FCM TOKEN
      // ========================================================

      // The login backend expects the legacy FCM registration token, not a FID.
      final String? token = (await _messaging.getToken())?.trim();
      if (token == null || token.isEmpty) {
        throw StateError('Firebase returned an empty FCM registration token.');
      }

      debugPrint('======================================');

      debugPrint('FCM TOKEN FOR LOGIN');

      debugPrint(token);

      debugPrint('======================================');

      return token;
    } catch (e, stackTrace) {
      debugPrint('GET FCM TOKEN ERROR: $e');

      debugPrint('$stackTrace');

      return null;
    }
  }

  Future<void> saveCurrentToken() async {
    try {
      final String? token = await getFcmToken();

      if (token == null || token.isEmpty) {
        debugPrint('FCM TOKEN NOT AVAILABLE');
        return;
      }

      _currentToken = token;

      debugPrint('================================');
      debugPrint('CURRENT FCM TOKEN READY');
      debugPrint('================================');

      // If you have a backend API for updating FCM tokens,
      // call it here after the farmer logs in.
    } catch (e) {
      debugPrint('SAVE CURRENT FCM TOKEN ERROR: $e');
    }
  }

  // =====================================================
  // GET CACHED TOKEN
  // =====================================================

  String? get currentToken => _currentToken;

  // =====================================================
  // TOKEN REFRESH LISTENER
  // =====================================================

  void listenTokenRefresh({
    Future<void> Function(String token)? onTokenChanged,
  }) {
    if (!_isAvailable) return;

    // Prevent duplicate listeners.
    if (_tokenRefreshSubscription != null) return;

    _tokenRefreshSubscription = _messaging.onTokenRefresh.listen(
      (String token) async {
        final refreshedToken = token.trim();

        if (refreshedToken.isEmpty) return;

        _currentToken = refreshedToken;

        debugPrint('================================');
        debugPrint('FCM TOKEN REFRESHED');
        debugPrint('================================');

        if (onTokenChanged != null) {
          try {
            await onTokenChanged(refreshedToken);
          } catch (e) {
            debugPrint('FCM TOKEN SYNC ERROR: $e');
          }
        }

        // If your backend requires FCM token updates,
        // send refreshedToken to that endpoint.
      },
      onError: (error) {
        debugPrint('FCM REFRESH ERROR: $error');
      },
    );
  }

  // =====================================================
  // DISPOSE LISTENER
  // =====================================================

  Future<void> dispose() async {
    await _tokenRefreshSubscription?.cancel();
    _tokenRefreshSubscription = null;
  }

  // ============================================================
  // TOKEN REFRESH
  // ============================================================
}
