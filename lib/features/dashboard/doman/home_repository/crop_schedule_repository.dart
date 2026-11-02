import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';

abstract class CropScheduleRepository {
  Future<List<CropSchedule>> getCropSchedules();

  Future<SuccessStoryEntity> getSuccessStoryList(
    String farmerId,
    String fromDate,
    String toDate,
    String startLimit,
  );

  Future<Response> updateNotificationStatus(String farmerId);
}
