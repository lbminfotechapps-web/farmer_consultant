
import 'package:farmer_consultant/features/notification/data/dataource/notification_remote_data_source.dart';
import 'package:farmer_consultant/features/notification/domain/entity/notification.dart';
import 'package:farmer_consultant/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(
    this.remoteDataSource,
  );

  @override
  Future<List<NotificationEntity>> getNotificationList({
    required int userId,
    required bool isLogin,
    required String userType,
    required int startLimit,
  }) {
    return remoteDataSource.getNotificationList(
      userId: userId,
      isLogin: isLogin,
      userType: userType,
      startLimit: startLimit,
    );
  }
}