import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';

abstract class CropScheduleRepository {
  Future<List<CropSchedule>> getCropSchedules();
}
