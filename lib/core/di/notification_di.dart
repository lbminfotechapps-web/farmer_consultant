
import 'package:farmer_consultant/features/notification/data/dataource/notification_remote_data_source.dart';
import 'package:farmer_consultant/features/notification/data/repository/notification_repository_impl.dart';
import 'package:farmer_consultant/features/notification/domain/repository/notification_repository.dart';
import 'package:farmer_consultant/features/notification/domain/usecase/get_notification_list.dart';
import 'package:farmer_consultant/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> initNotificationDi() async {
  // =========================================================
  // NOTIFICATION
  // =========================================================

  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      sl<NotificationRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<GetNotificationList>(
    () => GetNotificationList(
      sl<NotificationRepository>(),
    ),
  );

  sl.registerFactory<NotificationBloc>(
    () => NotificationBloc(
      sl<GetNotificationList>(),
    ),
  );
}

