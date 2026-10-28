import 'dart:async';

import 'package:farmer_consultant/core/di/crop_di.dart';
import 'package:farmer_consultant/core/notification/fcm_service.dart';
import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/core/router/app_router.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
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
import 'package:farmer_consultant/l10n/app_localizations.dart';

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
    this.notificationCount = 0,
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

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  late int _notificationCount;
  StreamSubscription<void>? _notificationSubscription;
  bool _isLoggingOut = false;
  DateTime? _activeFrom;
  DateTime? _activeTo;
  final DateFormat _apiFormat = DateFormat('dd-MM-yyyy');
  @override
  void initState() {
    super.initState();
    _notificationCount = widget.notificationCount;
    WidgetsBinding.instance.addObserver(this);
    _notificationSubscription = FcmService.notificationReceived.listen((_) {
      if (mounted) _loadNotifications();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadSchedules();
      _loadNotifications();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadNotifications();
  }

  Future<void> _openNotifications() async {
    if (widget.onNotificationTap != null) {
      widget.onNotificationTap!();
      return;
    }
    final farmerId = await SecureStorage.instance.getFarmerId();
    if (!mounted) return;
    await context.push(AppRouter.notification, extra: farmerId);
    if (mounted) await _loadNotifications();
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
      if (mounted) _showMessage(AppLocalizations.of(context)!.logoutError);
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
        // fromDate: _apiFormat.format(fromDate),
        // toDate: _apiFormat.format(toDate),
      ),
    );
  }

  Future<void> _loadNotifications() async {
    final farmerId = await SecureStorage.instance.getFarmerId();

    if (!mounted) return;

    final userId = int.tryParse(farmerId.trim());
    if (userId == null || userId <= 0) {
      debugPrint('Invalid farmer ID: $farmerId');
      return;
    }

    context.read<NotificationBloc>().add(
      GetNotificationListEvent(
        userId: userId,
        isLogin: true,
        userType: '',
        loadAll: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NotificationLoaded) {
          setState(() => _notificationCount = state.notifications.length);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CommonDashboardAppBar(
          backgroundColor: colors.surface,
          userName: widget.userName,
          greeting: '${strings.welcome},',
          location: widget.location,
          profileImage: widget.profileImage,
          notificationCount: _notificationCount,
          onNotificationTap: _openNotifications,
          onProfileTap: () {
            context.push('/profile');
            // _logout();
          },
        ),

        // Existing bottom navigation is managed by parent.
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        strings.farmAtAGlance,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat(
                        'dd MMM, yyyy',
                        strings.localeName,
                      ).format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const FarmingBanner(),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      strings.todaysActivities,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Crop Schedule
                BlocBuilder<CropBloc, CropState>(
                  builder: (context, state) {
                    return DashboardActivityCard(
                      title: strings.cropSchedule,
                      subtitle: strings.viewTodaysTasks,
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
                const SizedBox(height: 10),

                // Notifications
                DashboardActivityCard(
                  title: strings.notifications,
                  subtitle: _notificationCount == 0
                      ? strings.noNotificationsAvailable
                      : strings.totalNotificationCount(_notificationCount),
                  icon: Icons.notifications_rounded,

                  notificationCount: _notificationCount,
                  onTap: _openNotifications,
                ),

                const SizedBox(height: 26),
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
                    context.push(AppRouter.quickReferance);
                  },

                  onNearDealersTap: () {
                    context.push('/nearealers');
                  },

                  onContactUsTap: () {
                    context.push('/contactUs');
                  },

                  onImportantLinksTap: () {
                    context.push(AppRouter.importantLink);
                  },

                  onSocialMediaTap: () {
                    context.push('/social');
                  },

                  onAboutUsTap: () {
                    context.push('/aboutUs');
                  },

                  onCropAdviceTap: () {
                    context.push(AppRouter.cropSchedule);
                  },

                  onGalleryTap: () {
                    context.push(AppRouter.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
