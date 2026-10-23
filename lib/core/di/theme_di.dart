import 'package:farmer_consultant/core/theme/app_theme_colors.dart';
import 'package:farmer_consultant/core/theme/app_theme_palette.dart';
import 'package:farmer_consultant/core/theme/cubit/theme_cubit.dart';
import 'package:farmer_consultant/core/theme/data/theme_local_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ThemeDI {
  ThemeDI._();

  static Future<void> register(GetIt sl) async {
    // ========================================================
    // SHARED PREFERENCES
    // ========================================================

    if (!sl.isRegistered<SharedPreferencesAsync>()) {
      sl.registerLazySingleton<SharedPreferencesAsync>(
        () => SharedPreferencesAsync(),
      );
    }

    // ========================================================
    // LOCAL STORAGE SERVICE
    // ========================================================

    if (!sl.isRegistered<ThemeLocalStorage>()) {
      sl.registerLazySingleton<ThemeLocalStorage>(
        () => ThemeLocalStorage(
          sl<SharedPreferencesAsync>(),
        ),
      );
    }

    // ========================================================
    // READ SAVED THEME BEFORE CREATING CUBIT
    // ========================================================

    final storage = sl<ThemeLocalStorage>();

    final String? savedThemeId =
        await storage.getSavedThemeId();

    final AppThemePalette initialTheme =
        AppThemeColors.fromId(savedThemeId);

    // ========================================================
    // THEME CUBIT SINGLETON
    // ========================================================

    if (!sl.isRegistered<ThemeCubit>()) {
      sl.registerLazySingleton<ThemeCubit>(
        () => ThemeCubit(
          storage: storage,
          initialTheme: initialTheme,
        ),
      );
    }
  }
}
