
import 'package:farmer_consultant/features/notification/domain/entity/notification.dart';
import 'package:farmer_consultant/features/notification/domain/repository/notification_repository.dart';

class GetNotificationList {
  final NotificationRepository repository;

  const GetNotificationList(
    this.repository,
  );

  Future<List<NotificationEntity>> call({
    required int userId,
    required bool isLogin,
    required String userType,
    required int startLimit,
  }) {
    return repository.getNotificationList(
      userId: userId,
      isLogin: isLogin,
      userType: userType,
      startLimit: startLimit,
    );
  }
}