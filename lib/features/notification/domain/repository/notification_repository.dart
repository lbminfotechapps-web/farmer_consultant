
import 'package:farmer_consultant/features/notification/domain/entity/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getNotificationList({
    required int userId,
    required bool isLogin,
    required String userType,
    required int startLimit,
  });
}