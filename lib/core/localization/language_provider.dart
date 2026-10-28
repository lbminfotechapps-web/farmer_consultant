import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageScope extends InheritedNotifier<LanguageProvider> {
  const LanguageScope({
    super.key,
    required LanguageProvider languageProvider,
    required super.child,
  }) : super(notifier: languageProvider);

  static LanguageProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<LanguageScope>()!
        .notifier!;
  }
}

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LanguageProvider();

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString(_languageKey) ?? 'en';

    if (['en', 'hi', 'mr'].contains(languageCode)) {
      _locale = Locale(languageCode);
    } else {
      _locale = const Locale('en');
    }

    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!['en', 'hi', 'mr'].contains(languageCode)) {
      return;
    }

    if (_locale.languageCode == languageCode) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final saved = await prefs.setString(_languageKey, languageCode);
    if (!saved) throw StateError('Unable to save language preference');

    _locale = Locale(languageCode);
    notifyListeners();
  }

  String get currentLanguageCode => _locale.languageCode;
}
