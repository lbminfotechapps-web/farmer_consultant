import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_repository/crop_schedule_repository.dart';

class GetCropSchedules {
  final CropScheduleRepository repository;

  GetCropSchedules({required this.repository});

  Future<List<CropSchedule>> call() {
    return repository.getCropSchedules();
  }
}
