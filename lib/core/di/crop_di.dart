import 'package:farmer_consultant/core/api_constant/dio_client.dart';
import 'package:farmer_consultant/features/crop_schedule/data/crop_datasource/crop_datasource.dart';
import 'package:farmer_consultant/features/crop_schedule/data/crop_repository/crop_schedule_imp.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initCropDi() async {
  sl.registerLazySingleton<CropDatasource>(
    () => CropDatasource(sl<DioClient>()),
  );

  sl.registerLazySingleton<CropRepository>(
    () => CropScheduleImp(sl<CropDatasource>()),
  );

  sl.registerLazySingleton<CropScheduleUsecases>(
    () => CropScheduleUsecases(sl<CropRepository>()),
  );

  sl.registerFactory<CropBloc>(
    () => CropBloc(cropScheduleUsecases: sl<CropScheduleUsecases>()),
  );
}
