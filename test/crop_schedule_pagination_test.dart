import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements CropRepository {
  final offsets = <String>[];
  bool fail = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<ScheduleByPlotResponseEntity> getScheduleListByPlot(
    String farmerId,
    String plotId,
    String cropId,
    String fromDate,
    String toDate,
    String startLimit,
  ) async {
    offsets.add(startLimit);
    if (fail) throw Exception('Offline');
    final offset = int.parse(startLimit);
    return ScheduleByPlotResponseEntity(
      status: true,
      message: '',
      result: List.generate(
        offset == 0 ? 10 : 2,
        (index) => ScheduleByPlotEntity(
          status: '0',
          scheduleId: '${offset + index}',
          plotRegistrationId: plotId,
          scheduleDate: '',
          adminName: '',
          farmerName: '',
          cropId: '',
          cropName: '',
          plotName: 'Plot',
          remark: '',
          details: const [],
        ),
      ),
    );
  }
}

Future<void> _load(CropBloc bloc, String offset) async {
  final done = bloc.stream.firstWhere(
    (state) => state.cropStatus != CropStatus.loading && !state.loadingMore,
  );
  bloc.add(
    GetCropScheduleByPlotListEvent('farmer', 'plot', startLimit: offset),
  );
  await done;
}

void main() {
  test(
    'appends pages, preserves cards on failure, retries and resets',
    () async {
      final repository = _Repository();
      final bloc = CropBloc(
        cropScheduleUsecases: CropScheduleUsecases(repository),
      );
      addTearDown(bloc.close);
      await _load(bloc, '0');
      expect(bloc.state.scheduleByPlotList.length, 10);
      expect(bloc.state.nextScheduleOffset, 10);
      repository.fail = true;
      await _load(bloc, '10');
      expect(bloc.state.scheduleByPlotList.length, 10);
      expect(bloc.state.paginationError, isNotNull);
      expect(bloc.state.nextScheduleOffset, 10);
      repository.fail = false;
      await _load(bloc, '10');
      expect(bloc.state.scheduleByPlotList.length, 12);
      expect(bloc.state.hasMoreSchedules, isFalse);
      expect(bloc.state.paginationError, isNull);
      await _load(bloc, '0');
      expect(bloc.state.scheduleByPlotList.length, 10);
      expect(bloc.state.hasMoreSchedules, isTrue);
      expect(repository.offsets, ['0', '10', '10', '0']);
    },
  );
}
