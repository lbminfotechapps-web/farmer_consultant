import 'dart:async';

import 'package:farmer_consultant/core/notification/notification_navigation_service.dart';
import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

GoRouter _router() => GoRouter(
  initialLocation: AppRouter.splash,
  routes: [
    for (final path in [AppRouter.splash, AppRouter.login, AppRouter.dashboard])
      GoRoute(
        path: path,
        builder: (_, _) => Scaffold(body: Text(path)),
      ),
    GoRoute(
      path: AppRouter.notification,
      builder: (_, state) =>
          Scaffold(body: Text('Notifications for ${state.extra}')),
    ),
  ],
);

void main() {
  testWidgets('cold-start tap waits for splash and includes the farmer ID', (
    tester,
  ) async {
    final service = NotificationNavigationService(() async => '42');
    await service.handleNotification({});
    final router = _router();
    addTearDown(router.dispose);
    service.setRouter(router);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.text(AppRouter.splash), findsOneWidget);

    service.completeAuthentication(router: router, farmerId: '42');
    await tester.pumpAndSettle();
    expect(find.text('Notifications for 42'), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Notifications for 42'), findsOneWidget);
  });

  testWidgets('ordinary startup still opens the dashboard', (tester) async {
    final service = NotificationNavigationService(() async => '42');
    final router = _router();
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    service.completeAuthentication(router: router, farmerId: '42');
    await tester.pumpAndSettle();
    expect(find.text(AppRouter.dashboard), findsOneWidget);
  });

  testWidgets('taps while running open the list regardless of payload type', (
    tester,
  ) async {
    final service = NotificationNavigationService(() async => '42');
    final router = _router();
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    service.completeAuthentication(router: router, farmerId: '42');
    await tester.pumpAndSettle();

    for (final payload in <Map<String, dynamic>>[
      {},
      {'type': 'complaint'},
      {'notificationType': 'crop_schedule'},
    ]) {
      router.go(AppRouter.dashboard);
      await tester.pumpAndSettle();
      await service.handleNotification(payload);
      await tester.pumpAndSettle();
      expect(find.text('Notifications for 42'), findsOneWidget);
    }
  });

  testWidgets('signed-out cold start preserves the tap through login', (
    tester,
  ) async {
    final service = NotificationNavigationService(() async => '');
    final router = _router();
    addTearDown(router.dispose);
    await service.handleNotification({});
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    service.completeAuthentication(router: router, farmerId: '0');
    await tester.pumpAndSettle();
    expect(find.text(AppRouter.login), findsOneWidget);

    service.completeAuthentication(router: router, farmerId: '42');
    await tester.pumpAndSettle();
    expect(find.text('Notifications for 42'), findsOneWidget);
  });

  testWidgets('tap after logout requires login before opening the list', (
    tester,
  ) async {
    var farmerId = '42';
    final service = NotificationNavigationService(() async => farmerId);
    final router = _router();
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    service.completeAuthentication(router: router, farmerId: farmerId);
    await tester.pumpAndSettle();
    farmerId = '';
    await service.handleNotification({});
    await tester.pumpAndSettle();
    expect(find.text(AppRouter.login), findsOneWidget);
    farmerId = '51';
    service.completeAuthentication(router: router, farmerId: farmerId);
    await tester.pumpAndSettle();
    expect(find.text('Notifications for 51'), findsOneWidget);
  });

  testWidgets('overlapping tap callbacks cannot redirect back to home', (
    tester,
  ) async {
    final farmerId = Completer<String>();
    final service = NotificationNavigationService(() => farmerId.future);
    final router = _router();
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    service.completeAuthentication(router: router, farmerId: '42');
    await tester.pumpAndSettle();

    final first = service.handleNotification({});
    final second = service.handleNotification({});
    farmerId.complete('42');
    await Future.wait([first, second]);
    await tester.pumpAndSettle();
    expect(find.text('Notifications for 42'), findsOneWidget);
  });
}
