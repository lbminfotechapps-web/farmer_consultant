import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingCropRepository implements CropRepository {
  List<String>? arguments;

  @override
  Future<ScheduleResponseEntity> getFarmerScheduleList(
    String farmerId,
    String fromDate,
    String toDate,
  ) async {
    arguments = [farmerId, fromDate, toDate];
    return const ScheduleResponseEntity(status: true, message: '', result: []);
  }
}

void main() {
  test('schedule request preserves farmer ID and both date filters', () async {
    final repository = _RecordingCropRepository();
    await CropScheduleUsecases(
      repository,
    ).getFarmerScheduleList('1', '2026-10-19', '2026-10-21');
    expect(repository.arguments, ['1', '2026-10-19', '2026-10-21']);
  });
}
