import 'package:farmer_consultant/core/di/login_di.dart';
import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/core/theme/app_theme.dart';
import 'package:farmer_consultant/core/theme/cubit/theme_cubit.dart';
import 'package:farmer_consultant/core/theme/cubit/theme_state.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_bloc.dart';
import 'package:farmer_consultant/features/products/presentation/bloc/product_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>.value(value: sl<ThemeCubit>()),
        BlocProvider<LoginBloc>(create: (context) => sl<LoginBloc>()),
          BlocProvider<CropBloc>(create: (context) => sl<CropBloc>()),
                BlocProvider<ProductBloc>(create: (context) => sl<ProductBloc>()),
      ],
      child: ScreenUtilPlusInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => BlocBuilder<ThemeCubit, ThemeState>(
          buildWhen: (previous, current) {
            return previous.selectedTheme.id != current.selectedTheme.id;
          },

          builder: (context, themeState) {
            final selectedPalette = themeState.selectedTheme;

            final appTheme = AppColor.getLightTheme(selectedPalette);
            return MaterialApp.router(
              theme: appTheme,
              title: 'Farmer Consultant',
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              routerConfig: AppRouter.router,
            );
          },
        ),
      ),
    );
  }
}
