import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_repository/crop_schedule_repository.dart';

class GetCropSchedules {
  final CropScheduleRepository repository;

  GetCropSchedules({required this.repository});

  Future<List<CropSchedule>> call() {
    return repository.getCropSchedules();
  }

  Future<SuccessStoryEntity> getSuccessStoryList(
    String farmerId,
    String fromDate,
    String toDate,
    String startLimit,
  ) {
    return repository.getSuccessStoryList(
      farmerId,
      fromDate,
      toDate,
      startLimit,
    );
  }

  Future<Response> updateNotificationStatus(String farmerId) {
    return repository.updateNotificationStatus(farmerId);
  }
}
