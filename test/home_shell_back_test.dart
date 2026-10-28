import 'package:farmer_consultant/core/router/bottom_navigation.dart';
import 'package:farmer_consultant/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('system back returns tabs to Dashboard and preserves page back', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => HomeShell(navigationShell: shell),
          branches: [
            for (final path in ['dashboard', 'plots', 'products'])
              StatefulShellBranch(
                routes: [
                  GoRoute(
                    path: '/$path',
                    builder: (context, state) =>
                        Center(child: Text('$path page')),
                  ),
                ],
              ),
          ],
        ),
        GoRoute(
          path: '/details',
          builder: (context, state) => const Scaffold(body: Text('Details')),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(390, 844),
        builder: (context, child) => MaterialApp.router(
          theme: AppColor.getLightTheme(),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    for (final tab in ['Plots', 'Products']) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
      expect(find.text('${tab.toLowerCase()} page'), findsOneWidget);
      expect(await router.routerDelegate.popRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('dashboard page'), findsOneWidget);
    }

    await tester.tap(find.text('Products'));
    await tester.pumpAndSettle();
    router.push('/details');
    await tester.pumpAndSettle();
    expect(await router.routerDelegate.popRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('products page'), findsOneWidget);
    expect(await router.routerDelegate.popRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('dashboard page'), findsOneWidget);
    expect(await router.routerDelegate.popRoute(), isFalse);
  });
}
