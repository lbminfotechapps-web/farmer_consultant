import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class NotificationNavigationService {
  NotificationNavigationService._()
    : _readFarmerId = SecureStorage.instance.getFarmerId;

  @visibleForTesting
  NotificationNavigationService(this._readFarmerId);

  static final NotificationNavigationService instance =
      NotificationNavigationService._();

  final Future<String> Function() _readFarmerId;
  GoRouter? _router;
  bool _startupComplete = false;
  bool _pendingNotification = false;

  void setRouter(GoRouter router) {
    _router = router;
  }

  // Called after splash or login resolves the current user. A notification tap
  // takes precedence over the normal dashboard destination.
  void completeAuthentication({
    required GoRouter router,
    required String farmerId,
  }) {
    setRouter(router);
    _startupComplete = true;
    _openDestination(farmerId);
  }

  Future<void> handleNotification(Map<String, dynamic> data) async {
    // Even notifications without a data payload open the notification list.
    _pendingNotification = true;
    if (!_startupComplete || _router == null) return;

    try {
      final farmerId = await _readFarmerId();
      // Splash/login may have already consumed the tap during the storage read.
      if (!_pendingNotification) return;
      _openDestination(farmerId);
    } catch (error) {
      debugPrint('Unable to open notification list: $error');
    }
  }

  void _openDestination(String farmerId) {
    final router = _router!;
    final id = farmerId.trim();
    if (id.isEmpty || id == '0') {
      // Retain the notification destination until sign-in succeeds.
      router.go(AppRouter.login);
      return;
    }

    if (_pendingNotification) {
      _pendingNotification = false;
      router.go(AppRouter.notification, extra: id);
    } else {
      router.go(AppRouter.dashboard);
    }
  }
}
