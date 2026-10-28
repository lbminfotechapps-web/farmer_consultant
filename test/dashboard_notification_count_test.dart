import 'dart:math';

import 'package:farmer_consultant/core/theme/app_theme.dart';
import 'package:farmer_consultant/core/widgets/appbar.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/dashboard/presentation/pages/dashboard_screen.dart';
import 'package:farmer_consultant/features/dashboard/presentation/widgets/dashboard_activity_card.dart';
import 'package:farmer_consultant/features/notification/domain/entity/notification.dart';
import 'package:farmer_consultant/features/notification/domain/repository/notification_repository.dart';
import 'package:farmer_consultant/features/notification/domain/usecase/get_notification_list.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_event.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_state.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _Notifications extends NotificationRepository {
  _Notifications(this.total);
  int total;
  final offsets = <int>[];

  @override
  Future<List<NotificationEntity>> getNotificationList({
    required int userId,
    required bool isLogin,
    required String userType,
    required int startLimit,
  }) async {
    offsets.add(startLimit);
    return List.generate(min(20, max(0, total - startLimit)), (index) {
      return NotificationEntity(
        notificationId: '${startLimit + index}',
        title: 'Notification',
        message: '',
        notificationDate: '',
        notificationTime: '',
      );
    });
  }
}

class _Crops extends CropRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ScheduleResponseEntity> getFarmerScheduleList(
    String farmerId,
    String fromDate,
    String toDate,
  ) async =>
      const ScheduleResponseEntity(status: true, message: '', result: []);
}

void main() {
  for (final total in [0, 40, 45]) {
    test('dashboard request counts all $total notifications', () async {
      final repository = _Notifications(total);
      final bloc = NotificationBloc(GetNotificationList(repository));
      addTearDown(bloc.close);
      final loaded = bloc.stream.firstWhere((s) => s is NotificationLoaded);
      bloc.add(
        const GetNotificationListEvent(
          userId: 42,
          isLogin: true,
          userType: '',
          loadAll: true,
        ),
      );
      final state = await loaded as NotificationLoaded;
      expect(state.notifications.length, total);
      expect(state.hasMore, isFalse);
      expect(repository.offsets, total == 0 ? [0] : [0, 20, 40]);
    });
  }

  test('notification list still fetches only one page by default', () async {
    final repository = _Notifications(45);
    final bloc = NotificationBloc(GetNotificationList(repository));
    addTearDown(bloc.close);
    final loaded = bloc.stream.firstWhere((s) => s is NotificationLoaded);
    bloc.add(
      const GetNotificationListEvent(userId: 42, isLogin: true, userType: ''),
    );
    final state = await loaded as NotificationLoaded;
    expect(state.notifications.length, 20);
    expect(state.hasMore, isTrue);
    expect(repository.offsets, [0]);
  });

  testWidgets(
    'dashboard card and bell use the fetched total and refresh to zero',
    (tester) async {
      FlutterSecureStorage.setMockInitialValues({
        'user_data': '{"fld_farmer_id":"42","fld_farmer_name":"Farmer"}',
      });
      final repository = _Notifications(45);
      final notifications = NotificationBloc(GetNotificationList(repository));
      final crops = CropBloc(
        cropScheduleUsecases: CropScheduleUsecases(_Crops()),
      );
      addTearDown(notifications.close);
      addTearDown(crops.close);
      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<NotificationBloc>.value(value: notifications),
            BlocProvider<CropBloc>.value(value: crops),
          ],
          child: ScreenUtilPlusInit(
            designSize: const Size(390, 844),
            builder: (_, _) => MaterialApp(
              theme: AppColor.getLightTheme(),
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              home: const DashboardScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      DashboardActivityCard notificationCard() => tester
          .widgetList<DashboardActivityCard>(find.byType(DashboardActivityCard))
          .firstWhere((card) => card.title == 'Notifications');

      expect(notificationCard().notificationCount, 45);
      expect(notificationCard().subtitle, '45 notifications');
      expect(
        tester
            .widget<CommonDashboardAppBar>(find.byType(CommonDashboardAppBar))
            .notificationCount,
        45,
      );
      repository.total = 0;
      notifications.add(
        const GetNotificationListEvent(
          userId: 42,
          isLogin: true,
          userType: '',
          loadAll: true,
        ),
      );
      await tester.pumpAndSettle();
      expect(notificationCard().notificationCount, 0);
      expect(notificationCard().subtitle, 'No notifications available');
      expect(tester.takeException(), isNull);
    },
  );
}
