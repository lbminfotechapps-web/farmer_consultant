import 'package:farmer_consultant/core/localization/language_provider.dart';
import 'package:farmer_consultant/core/theme/app_theme.dart';
import 'package:farmer_consultant/features/login/presentation/pages/profile_screen.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('defaults to English and restores supported language choices', () async {
    final provider = LanguageProvider();
    addTearDown(provider.dispose);
    await provider.loadLanguage();
    expect(provider.currentLanguageCode, 'en');
    for (final code in ['mr', 'hi', 'en']) {
      await provider.changeLanguage(code);
      final restored = LanguageProvider();
      await restored.loadLanguage();
      expect(restored.currentLanguageCode, code);
      restored.dispose();
    }
    await provider.changeLanguage('unsupported');
    expect(provider.currentLanguageCode, 'en');
  });

  testWidgets('profile selector changes language and translates profile', (
    tester,
  ) async {
    final provider = LanguageProvider();
    addTearDown(provider.dispose);
    await provider.loadLanguage();
    await tester.pumpWidget(
      LanguageScope(
        languageProvider: provider,
        child: ScreenUtilPlusInit(
          designSize: const Size(390, 844),
          builder: (context, child) => ListenableBuilder(
            listenable: provider,
            builder: (context, child) => MaterialApp(
              theme: AppColor.getLightTheme(),
              locale: provider.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const ProfileScreen(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Language'));
    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    expect(find.text('English'), findsWidgets);
    expect(find.text('मराठी'), findsOneWidget);
    expect(find.text('हिन्दी'), findsOneWidget);
    await tester.tap(find.text('मराठी'));
    await tester.pumpAndSettle();
    expect(provider.currentLanguageCode, 'mr');
    expect(find.text('भाषा'), findsOneWidget);
    expect(find.text('मराठी'), findsOneWidget);
    expect(find.text('वैयक्तिक माहिती'), findsOneWidget);
    final restored = LanguageProvider();
    await restored.loadLanguage();
    expect(restored.currentLanguageCode, 'mr');
    restored.dispose();

    await tester.tap(find.text('भाषा'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();
    expect(provider.currentLanguageCode, 'hi');
    expect(find.text('व्यक्तिगत जानकारी'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
