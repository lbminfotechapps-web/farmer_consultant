import 'package:farmer_consultant/core/di/login_di.dart';
import 'package:farmer_consultant/core/localization/language_provider.dart';
import 'package:farmer_consultant/core/notification/notification_navigation_service.dart';
import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/core/theme/app_theme.dart';
import 'package:farmer_consultant/core/theme/cubit/theme_cubit.dart';
import 'package:farmer_consultant/core/theme/cubit/theme_state.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_bloc.dart';
import 'package:farmer_consultant/features/important_links/presentation/bloc/important_links_bloc.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_bloc.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_bloc.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:farmer_consultant/features/products/presentation/bloc/product_bloc.dart';
import 'package:farmer_consultant/features/quickchartreport/presentation/bloc/gallerybloc.dart';
import 'package:farmer_consultant/features/report/presentation/bloc/organization_bloc.dart';
import 'package:farmer_consultant/features/social/presentation/bloc/social_media_bloc.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MyApp extends StatelessWidget {
  final LanguageProvider languageProvider;

  const MyApp({super.key, required this.languageProvider});

  @override
  Widget build(BuildContext context) {
    NotificationNavigationService.instance.setRouter(AppRouter.router);
    return LanguageScope(
      languageProvider: languageProvider,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),

          BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),

          BlocProvider<CropBloc>(create: (context) => sl<CropBloc>()),

          BlocProvider<ProductBloc>(create: (context) => sl<ProductBloc>()),

          BlocProvider<GalleryBloc>(create: (context) => sl<GalleryBloc>()),

          BlocProvider<ImportantLinksBloc>(
            create: (context) => sl<ImportantLinksBloc>(),
          ),

          BlocProvider<CropScheduleBloc>(
            create: (context) => sl<CropScheduleBloc>(),
          ),

          BlocProvider<OrganizationBloc>(
            create: (context) => sl<OrganizationBloc>(),
          ),

          BlocProvider<SocialMediaBloc>(
            create: (context) => sl<SocialMediaBloc>(),
          ),

          BlocProvider<NotificationBloc>(
            create: (context) => sl<NotificationBloc>(),
          ),

          BlocProvider<DealerListBloc>(
            create: (context) => sl<DealerListBloc>(),
          ),
        ],

        child: ScreenUtilPlusInit(
          minTextAdapt: true,
          splitScreenMode: true,

          builder: (context, child) {
            return ListenableBuilder(
              listenable: languageProvider,

              builder: (context, child) {
                return BlocBuilder<ThemeCubit, ThemeState>(
                  buildWhen: (previous, current) {
                    return previous.selectedTheme.id !=
                        current.selectedTheme.id;
                  },

                  builder: (context, themeState) {
                    final selectedPalette = themeState.selectedTheme;

                    final appTheme = AppColor.getLightTheme(selectedPalette);

                    return MaterialApp.router(
                      // EXISTING THEME
                      theme: appTheme,

                      themeMode: ThemeMode.light,

                      debugShowCheckedModeBanner: false,

                      // EXISTING ROUTER
                      routerConfig: AppRouter.router,

                      // GLOBAL APP LANGUAGE
                      locale: languageProvider.locale,

                      // SUPPORTED LANGUAGES
                      supportedLocales: AppLocalizations.supportedLocales,

                      // LOCALIZATION DELEGATES
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,

                      // APP TITLE
                      onGenerateTitle: (context) {
                        return AppLocalizations.of(context)!.appName;
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//    final LanguageProvider languageProvider;
//   const MyApp({super.key, required this.languageProvider});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
//         BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
//         BlocProvider<CropBloc>(create: (context) => sl<CropBloc>()),
//         BlocProvider<ProductBloc>(create: (context) => sl<ProductBloc>()),
//         BlocProvider<GalleryBloc>(create: (context) => sl<GalleryBloc>()),
//         BlocProvider<ImportantLinksBloc>(
//           create: (context) => sl<ImportantLinksBloc>(),
//         ),
//         BlocProvider<CropScheduleBloc>(
//           create: (context) => sl<CropScheduleBloc>(),
//         ),
//         BlocProvider<OrganizationBloc>(
//           create: (context) => sl<OrganizationBloc>(),
//         ),
//         BlocProvider<SocialMediaBloc>(
//           create: (context) => sl<SocialMediaBloc>(),
//         ),
//         BlocProvider<NotificationBloc>(
//           create: (context) => sl<NotificationBloc>(),
//         ),

//         BlocProvider<DealerListBloc>(create: (context) => sl<DealerListBloc>()),
//       ],
//       child: ScreenUtilPlusInit(
//         minTextAdapt: true,
//         splitScreenMode: true,
//         builder: (context, child) => BlocBuilder<ThemeCubit, ThemeState>(
//           buildWhen: (previous, current) {
//             return previous.selectedTheme.id != current.selectedTheme.id;
//           },

//           builder: (context, themeState) {
//             final selectedPalette = themeState.selectedTheme;

//             final appTheme = AppColor.getLightTheme(selectedPalette);
//             return MaterialApp.router(
//               theme: appTheme,
//               title: 'Farmer Consultant',
//               themeMode: ThemeMode.light,
//               debugShowCheckedModeBanner: false,
//               routerConfig: AppRouter.router,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
