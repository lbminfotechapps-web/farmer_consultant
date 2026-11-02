import 'package:farmer_consultant/features/notification/domain/entity/notification.dart';
import 'package:farmer_consultant/features/notification/domain/repository/notification_repository.dart';
import 'package:farmer_consultant/features/notification/domain/usecase/get_notification_list.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_event.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _RepeatedPageRepository extends NotificationRepository {
  final offsets = <int>[];

  @override
  Future<List<NotificationEntity>> getNotificationList({
    required int userId,
    required bool isLogin,
    required String userType,
    required int startLimit,
  }) async {
    offsets.add(startLimit);
    // Fail promptly if the regression returns instead of hanging the test.
    if (offsets.length > 3) throw StateError('Pagination did not stop');
    return List.generate(
      22,
      (index) => NotificationEntity(
        notificationId: '$index',
        title: '',
        message: '',
        notificationDate: '',
        notificationTime: '',
        seenFlag: '0',
      ),
    );
  }
}

void main() {
  for (final loadAll in [true, false]) {
    test('repeated page stops pagination with loadAll=$loadAll', () async {
      final repository = _RepeatedPageRepository();
      final bloc = NotificationBloc(GetNotificationList(repository));
      addTearDown(bloc.close);
      final first = bloc.stream.firstWhere(
        (state) => state is NotificationLoaded,
      );
      bloc.add(
        GetNotificationListEvent(
          userId: 1,
          isLogin: true,
          userType: '',
          loadAll: loadAll,
        ),
      );
      var state = await first as NotificationLoaded;
      if (!loadAll) {
        final next = bloc.stream.firstWhere(
          (state) => state is NotificationLoaded && !state.isLoadingMore,
        );
        bloc.add(const LoadMoreNotificationsEvent());
        state = await next as NotificationLoaded;
      }
      expect(state.notifications.length, 22);
      expect(
        state.notifications.map((item) => item.notificationId).toSet().length,
        22,
      );
      expect(state.hasMore, isFalse);
      expect(repository.offsets, [0, 22]);
      bloc.add(const LoadMoreNotificationsEvent());
      await Future<void>.delayed(Duration.zero);
      expect(repository.offsets, [0, 22]);
    });
  }
}
