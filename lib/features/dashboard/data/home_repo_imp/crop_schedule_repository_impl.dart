import 'package:farmer_consultant/features/dashboard/data/home_datasource/crop_schedule_remote_data_source.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_repository/crop_schedule_repository.dart';

class CropScheduleRepositoryImpl implements CropScheduleRepository {
  final CropScheduleRemoteDataSource remoteDataSource;

  CropScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CropSchedule>> getCropSchedules() {
    return remoteDataSource.getCropSchedules();
  }
}
