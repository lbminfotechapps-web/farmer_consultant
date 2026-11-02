import 'package:dio/src/response.dart';
import 'package:farmer_consultant/features/dashboard/data/home_datasource/crop_schedule_remote_data_source.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_repository/crop_schedule_repository.dart';

class CropScheduleRepositoryImpl implements CropScheduleRepository {
  final CropScheduleRemoteDataSource remoteDataSource;

  CropScheduleRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CropSchedule>> getCropSchedules() {
    return remoteDataSource.getCropSchedules();
  }

  @override
  Future<SuccessStoryEntity> getSuccessStoryList(
    String farmerId,
    String fromDate,
    String toDate,
    String startLimit,
  ) {
    return remoteDataSource.getSuccessStoryList(
      farmerId,
      fromDate,
      toDate,
      startLimit,
    );
  }

  @override
  Future<Response<dynamic>> updateNotificationStatus(String farmerId) {
    return remoteDataSource.updateNotificationStatus(farmerId);
  }
}
