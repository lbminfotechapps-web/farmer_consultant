import 'package:farmer_consultant/features/dashboard/presentation/widgets/dashboarrd_menu.dart';
import 'package:farmer_consultant/features/dashboard/presentation/widgets/farmer_banner.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final code in ['en', 'mr', 'hi']) {
    testWidgets('dashboard content renders in $code on a narrow screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(code),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: const Scaffold(
            body: SingleChildScrollView(
              child: Column(children: [FarmingBanner(), DashboardMenu()]),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final strings = await AppLocalizations.delegate.load(Locale(code));
      expect(find.text(strings.growSmarter), findsOneWidget);
      expect(find.text(strings.quickAccess), findsOneWidget);
      expect(find.text(strings.myPlots), findsOneWidget);
      expect(find.text(strings.contactUs), findsOneWidget);
      expect(strings.newAlerts(1), isNot(strings.newAlerts(2)));
      expect(tester.takeException(), isNull);
    });
  }
}
