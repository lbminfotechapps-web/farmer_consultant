import 'package:farmer_consultant/core/di/global_di.dart';
import 'package:farmer_consultant/core/router/bottom_navigation.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/crop_schedul_by_plot.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/crop_schedule_list_page.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/plot_finance.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/plot_list.dart';
import 'package:farmer_consultant/features/dashboard/presentation/pages/crop_schedule_page.dart';
import 'package:farmer_consultant/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:farmer_consultant/features/dealer/presentation/pages/DealerListScreen.dart';
import 'package:farmer_consultant/features/gallery/presentation/pages/galleryscreen.dart';
import 'package:farmer_consultant/features/important_links/presentation/pages/important_links_page.dart';
import 'package:farmer_consultant/features/login/presentation/pages/login_screen.dart';
import 'package:farmer_consultant/features/login/presentation/pages/profile_screen.dart';
import 'package:farmer_consultant/features/notification/presentation/pages/notifications.dart';
import 'package:farmer_consultant/features/products/domain/entity/fertilizer_category_entity.dart';
import 'package:farmer_consultant/features/products/domain/entity/fertilizer_product_entity.dart';
import 'package:farmer_consultant/features/products/presentation/pages/product_details.dart';
import 'package:farmer_consultant/features/products/presentation/pages/product_list.dart';
import 'package:farmer_consultant/features/products/presentation/pages/products_screen.dart';
import 'package:farmer_consultant/features/quickchartreport/presentation/pages/quick_referance_page.dart';
import 'package:farmer_consultant/features/quickchartreport/presentation/bloc/gallerybloc.dart';
import 'package:farmer_consultant/features/report/presentation/pages/about_us_page.dart';
import 'package:farmer_consultant/features/report/presentation/pages/contact_us_page.dart';
import 'package:farmer_consultant/features/social/presentation/pages/social_media_page.dart';
import 'package:farmer_consultant/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String activity = '/activity';
  static const String profile = '/profile';
  static const String cropScheduleList = '/cropScheduleList';
  static const String weatherreport = '/weatherreport';
  static const String products = '/products';
  static const String productList = '/productList';
  static const String productDetails = '/productDetails';
  static const String productEnquiry = '/productEnquiry';
  static const String plotList = '/plotList';
  static const String quickReferance = '/quickReferance';
  static const String gallery = '/gallery';
  static const String cropScheduleByPlot = '/cropScheduleByPlot';
  static const String notification = '/notification';
  static const String cropSchedule = '/cropSchedule';
  static const String contactUs = '/contactUs';
  static const String aboutUs = '/aboutUs';
  static const String social = '/social';
  static const String importantLink = '/importantLink';
  static const String nearealers = '/nearealers';

  static const String plotFinance = '/plotFinance';

  static final GoRouter router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: splash,
    routes: [
      // Splash - no bottom navigation
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Login - no bottom navigation
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: cropScheduleList,
        name: 'cropScheduleList',
        builder: (context, state) {
          final extra = state.extra;
          final farmerId = extra is String || extra is int
              ? extra.toString().trim()
              : '';
          return CropSchedulePage(farmerId: farmerId);
        },
      ),

      GoRoute(
        path: weatherreport,
        name: 'weatherreport',
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: importantLink,
        name: 'importantLink',
        builder: (context, state) => const ImportantLinksPage(),
      ),

      GoRoute(
        path: productList,
        name: 'productList',
        builder: (context, state) {
          final productList = state.extra is FertilizerCategoryEntity
              ? state.extra as FertilizerCategoryEntity
              : null;
          return ProductList(productList);
        },
      ),

      GoRoute(
        path: productDetails,
        name: 'productDetails',
        builder: (context, state) {
          final productDetails = state.extra is FertilizerProductEntity
              ? state.extra as FertilizerProductEntity
              : null;
          return ProductDetails(productDetails);
        },
      ),

      GoRoute(
        path: gallery,
        name: 'gallery',
        builder: (context, state) {
          return const GalleryScreen();
        },
      ),

      GoRoute(
        path: quickReferance,
        name: 'quickReferance',
        builder: (context, state) {
          return BlocProvider<GalleryBloc>(
            create: (_) => sl<GalleryBloc>(),
            child: const QuickReferencePage(),
          );
        },
      ),

      GoRoute(
        path: cropScheduleByPlot,
        name: 'cropScheduleByPlot',
        builder: (context, state) {
          final plotId = state.extra as String? ?? '';

          return CropSchedulByPlot(plotId: plotId);
        },
      ),

      GoRoute(
        path: notification,
        name: 'notification',
        builder: (context, state) {
          final userId = state.extra is String
              ? int.tryParse(state.extra as String) ?? 0
              : state.extra is int
              ? state.extra as int
              : 0;

          return NotificationPage(userId: userId, isLogin: true, userType: '');
        },
      ),

      GoRoute(
        path: cropSchedule,
        name: 'cropSchedule',
        builder: (context, state) {
          return const CropScheduleAdvicePage();
        },
      ),

      GoRoute(
        path: contactUs,
        name: 'contactUs',
        builder: (context, state) {
          return const ContactUsPage();
        },
      ),

      GoRoute(
        path: aboutUs,
        name: 'aboutUs',
        builder: (context, state) {
          return const AboutUsPage();
        },
      ),

      GoRoute(
        path: social,
        name: 'social',
        builder: (context, state) {
          return const SocialMediaPage();
        },
      ),

      GoRoute(
        path: nearealers,
        name: 'nearealers',
        builder: (context, state) {
          return const DealerListScreen();
        },
      ),

      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: plotFinance,
        name: 'plotFinance',
        builder: (context, state) {
          final details = state.extra as Map<String, String>? ?? const {};

          return PlotFinanceScreen(
            plotId: details['plotId'] ?? '',
            acres: details['acres'] ?? '',
            cropName: details['cropName'] ?? '',
            plotName: details['plotName'] ?? '',
          );
        },
        // builder: (context, state) => const (),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),

          // Tab 1: Activity
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: plotList,
                name: 'plotList',
                builder: (context, state) {
                  return PlotList();
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: products,
                name: 'products',
                builder: (context, state) {
                  return const ProductCategoryScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
