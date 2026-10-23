import 'package:farmer_consultant/core/router/bottom_navigation.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/crop_schedul_by_plot.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/crop_schedule_list_page.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/pages/plot_list.dart';
import 'package:farmer_consultant/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:farmer_consultant/features/login/presentation/pages/login_screen.dart';
import 'package:farmer_consultant/features/products/domain/entity/fertilizer_category_entity.dart';
import 'package:farmer_consultant/features/products/domain/entity/fertilizer_product_entity.dart';
import 'package:farmer_consultant/features/products/presentation/pages/product_details.dart';
import 'package:farmer_consultant/features/products/presentation/pages/product_list.dart';
import 'package:farmer_consultant/features/products/presentation/pages/products_screen.dart';
import 'package:farmer_consultant/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
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
  static const String cropScheduleByPlot = '/cropScheduleByPlot';

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
        path: plotList,
        name: 'plotList',
        builder: (context, state) {
          return PlotList();
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

      //       GoRoute(
      //   path: productEnquiry,
      //   name: 'productEnquiry',
      //   builder: (context, state) {
      //     final extra = state.extra as Map<String, dynamic>?;

      //     final String productId = extra?['productId']?.toString() ?? '';

      //     final String productName = extra?['productName']?.toString() ?? '';

      //     return EnquiryPage(productId: productId, productName: productName);
      //   },
      // ),
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
                path: activity,
                name: 'activity',
                builder: (context, state) => const _PlaceholderScreen(
                  title: 'Activity',
                  icon: Icons.history_rounded,
                ),
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
          // Tab 2: Profile
          // StatefulShellBranch(
          //   routes: [
          //     GoRoute(
          //       path: profile,
          //       name: 'profile',
          //       builder: (context, state) => const _PlaceholderScreen(
          //         title: 'Profile',
          //         icon: Icons.person_rounded,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    ],
  );
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _PlaceholderScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
