import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/dashboard/data/home_datasource/crop_schedule_remote_data_source.dart';
import 'package:farmer_consultant/features/dashboard/data/home_repo_imp/crop_schedule_repository_impl.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_repository/crop_schedule_repository.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_usecases/get_crop_schedules.dart';
import 'package:farmer_consultant/features/dashboard/presentation/home_bloc/crop_schedule_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initCropScheduleDi() async {
  // =========================================================
  // DATA SOURCE
  // =========================================================

  sl.registerLazySingleton<CropScheduleRemoteDataSource>(
    () => CropScheduleRemoteDataSource(dioClient: sl<DioClient>()),
  );

  // =========================================================
  // REPOSITORY
  // =========================================================

  sl.registerLazySingleton<CropScheduleRepository>(
    () => CropScheduleRepositoryImpl(
      remoteDataSource: sl<CropScheduleRemoteDataSource>(),
    ),
  );

  // =========================================================
  // USE CASE
  // =========================================================

  sl.registerLazySingleton<GetCropSchedules>(
    () => GetCropSchedules(repository: sl<CropScheduleRepository>()),
  );

  // =========================================================
  // BLOC
  // =========================================================

  sl.registerFactory<CropScheduleBloc>(
    () => CropScheduleBloc(getCropSchedules: sl<GetCropSchedules>()),
  );
}
