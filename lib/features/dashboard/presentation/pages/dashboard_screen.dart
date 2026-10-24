import 'package:farmer_consultant/core/di/crop_di.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:farmer_consultant/features/dashboard/presentation/widgets/dashboard_action.dart';
import 'package:farmer_consultant/features/dashboard/presentation/widgets/dashboarrd_menu.dart';
import 'package:farmer_consultant/features/dashboard/presentation/widgets/farmer_banner.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_event.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_state.dart';
import 'package:farmer_consultant/features/weather/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../widgets/dashboard_activity_card.dart';

class DashboardScreen extends StatefulWidget {
  final String userName;
  final String location;
  final String? profileImage;
  final int notificationCount;

  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCropCareTap;
  final VoidCallback? onDiseaseCheckTap;
  final VoidCallback? onWeatherTap;
  final VoidCallback? onMyFieldsTap;
  final VoidCallback? onCropScheduleTap;
  final VoidCallback? onAiDiagnosisTap;

  const DashboardScreen({
    super.key,
    this.userName = '',
    this.location = 'Nashik, Maharashtra',
    this.profileImage,
    this.notificationCount = 2,
    this.onProfileTap,
    this.onNotificationTap,
    this.onCropCareTap,
    this.onDiseaseCheckTap,
    this.onWeatherTap,
    this.onMyFieldsTap,
    this.onCropScheduleTap,
    this.onAiDiagnosisTap,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoggingOut = false;
  DateTime? _activeFrom;
  DateTime? _activeTo;
  final DateFormat _apiFormat = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadSchedules();
      _loadNotifications();
    });
  }

  Future<void> _logout() async {
    if (_isLoggingOut) {
      return;
    }
    setState(() => _isLoggingOut = true);
    try {
      final storage = sl<SecureStorage>();

      await storage.clearUserData();
      if (!mounted) return;
      context.go(AppRouter.login);
    } catch (_) {
      if (mounted) _showMessage('Unable to log out. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoggingOut = false);
    }
  }

  int _getScheduleCount(CropState state) {
    if (state.cropStatus != CropStatus.success) {
      return 0;
    }

    final today = DateTime.now();

    final fromDate =
        _activeFrom ?? DateTime(today.year, today.month, today.day);

    final toDate = _activeTo ?? fromDate;

    return state.sceduleentityList.where((schedule) {
      final date = DateFormat(
        'dd-MM-yyyy',
      ).tryParseStrict(schedule.scheduleDate.trim());

      if (date == null) return false;

      final scheduleDay = DateTime(date.year, date.month, date.day);
      final fromDay = DateTime(fromDate.year, fromDate.month, fromDate.day);
      final toDay = DateTime(toDate.year, toDate.month, toDate.day);

      return !scheduleDay.isBefore(fromDay) && !scheduleDay.isAfter(toDay);
    }).length;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _loadSchedules() async {
    final String farmerId = await SecureStorage.instance.getFarmerId();

    if (!mounted) return;

    final today = DateTime.now();

    final fromDate = _activeFrom ?? today;
    final toDate = _activeTo ?? today;

    debugPrint('========== DASHBOARD SCHEDULE API ==========');
    debugPrint('farmerId: $farmerId');
    debugPrint('fromDate: ${_apiFormat.format(fromDate)}');
    debugPrint('toDate: ${_apiFormat.format(toDate)}');

    context.read<CropBloc>().add(
      GetCropScheduleEvent(
        farmerId,
        fromDate: _apiFormat.format(fromDate),
        toDate: _apiFormat.format(toDate),
      ),
    );
  }

  Future<void> _loadNotifications() async {
    final farmerId = await SecureStorage.instance.getFarmerId();

    if (!mounted) return;

    final userId = int.tryParse(farmerId.trim());
    if (userId == null) {
      debugPrint('Invalid farmer ID: $farmerId');
      return;
    }

    context.read<NotificationBloc>().add(
      GetNotificationListEvent(userId: userId, isLogin: true, userType: ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CommonDashboardAppBar(
        userName: widget.userName,
        location: widget.location,
        profileImage: widget.profileImage,
        notificationCount: widget.notificationCount,
        onNotificationTap: widget.onNotificationTap,
        onProfileTap: () {
          _logout();
        },
      ),

      // Existing bottom navigation is managed by parent.
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(15, 8, 15, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Smart Farming Banner
              const FarmingBanner(),

              const SizedBox(height: 15),

              // Quick Actions
              // Row(
              //   children: [
              //     // Expanded(
              //     //   child: DashboardQuickAction(
              //     //     title: 'Crop Care',
              //     //     icon: Icons.yard_rounded,
              //     //     onTap: onCropCareTap ?? () {},
              //     //   ),
              //     // ),
              //     // Expanded(
              //     //   child: DashboardQuickAction(
              //     //     title: 'Disease Check',
              //     //     icon: Icons.health_and_safety_outlined,
              //     //     onTap: onDiseaseCheckTap ?? () {},
              //     //   ),
              //     // ),
              //     Expanded(
              //       child: DashboardQuickAction(
              //         title: 'Weather',
              //         icon: Icons.wb_cloudy_outlined,
              //         onTap:
              //             widget.onWeatherTap ??
              //             () {
              //               WeatherCardDialog.show(context);
              //             },
              //       ),
              //     ),
              //     Expanded(
              //       child: DashboardQuickAction(
              //         title: 'My Plots',
              //         icon: Icons.grass_rounded,
              //         // iconColor: context.appColors.secondary,
              //         onTap:
              //             widget.onMyFieldsTap ??
              //             () {
              //               context.push(AppRouter.plotList);
              //             },
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: [
                  Icon(Icons.local_activity_outlined, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Activities",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),

              // Crop Schedule
              BlocBuilder<CropBloc, CropState>(
                builder: (context, state) {
                  return DashboardActivityCard(
                    title: 'Crop Schedule',
                    subtitle: "View today's tasks",
                    icon: Icons.calendar_month_rounded,
                    onTap:
                        widget.onCropScheduleTap ??
                        () async {
                          final String farmerId = await SecureStorage.instance
                              .getFarmerId();
                          if (!context.mounted) return;
                          await context.push(
                            AppRouter.cropScheduleList,
                            extra: farmerId,
                          );
                          if (!mounted) return;
                          await _loadSchedules();

                          debugPrint('Farmer ID: $farmerId');
                        },
                    notificationCount: state.cropStatus == CropStatus.success
                        ? _getScheduleCount(state)
                        : null,
                  );
                },
              ),

              // const SizedBox(height: 5),

              // Notifications
              DashboardActivityCard(
                title: 'Notifications',
                subtitle: widget.notificationCount == 0
                    ? 'No new alerts'
                    : '${widget.notificationCount} new alerts',
                icon: Icons.notifications_rounded,

                notificationCount: widget.notificationCount,
                onTap:
                    widget.onNotificationTap ??
                    () async {
                      final String farmerId = await SecureStorage.instance
                          .getFarmerId();
                      if (!context.mounted) return;
                      context.push('/notification', extra: farmerId);
                    },
              ),

              Divider(height: 1, color: context.borderColor),

              const SizedBox(height: 18),
              DashboardMenu(
                onWeatherTap:
                    widget.onWeatherTap ??
                    () {
                      WeatherCardDialog.show(context);
                    },

                onMyPlotsTap:
                    widget.onMyFieldsTap ??
                    () {
                      context.push(AppRouter.plotList);
                    },

                onQuickReferenceTap: () {
                  _showMessage('Quick Reference');
                },

                onNearDealersTap: () {
                  _showMessage('Near Dealers');
                },

                onContactUsTap: () {
                  _showMessage('Contact Us');
                },

                onImportantLinksTap: () {
                  _showMessage('Important Links');
                },

                onSocialMediaTap: () {
                  _showMessage('Social Media');
                },

                onAboutUsTap: () {
                  _showMessage('About Us');
                },

                onCropAdviceTap: () {
                  _showMessage('Crop Advice');
                },

                onGalleryTap: () {
                  _showMessage('Gallery');
                },
              ),

              // Today's Activities Header

              // BlocBuilder<NotificationBloc, NotificationState>(
              //   builder: (context, state) {
              //     return DashboardActivityCard(
              //       title: 'Notifications',
              //       subtitle: widget.notificationCount == 0
              //           ? 'No new alerts'
              //           : '${widget.notificationCount} new alerts',
              //       icon: Icons.notifications_rounded,

              //       notificationCount: widget.notificationCount,
              //       onTap:
              //           widget.onNotificationTap ??
              //           () async {
              //             final String farmerId = await SecureStorage.instance
              //                 .getFarmerId();
              //             if (!context.mounted) return;
              //             context.push('/notification', extra: farmerId);
              //           },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
