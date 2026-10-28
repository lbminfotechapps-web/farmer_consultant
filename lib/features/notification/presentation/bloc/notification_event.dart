abstract class NotificationEvent {
  const NotificationEvent();
}

class GetNotificationListEvent extends NotificationEvent {
  final int userId;
  final bool isLogin;
  final String userType;
  final bool loadAll;

  const GetNotificationListEvent({
    required this.userId,
    required this.isLogin,
    required this.userType,
    this.loadAll = false,
  });
}

class LoadMoreNotificationsEvent extends NotificationEvent {
  const LoadMoreNotificationsEvent();
}

class RefreshNotificationListEvent extends NotificationEvent {
  final int userId;
  final bool isLogin;
  final String userType;

  const RefreshNotificationListEvent({
    required this.userId,
    required this.isLogin,
    required this.userType,
  });
}
