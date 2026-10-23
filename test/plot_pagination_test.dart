import 'package:farmer_consultant/features/crop_schedule/domain/entity/plot_response_entity.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements CropRepository {
  final offsets = <String>[];
  bool fail = false;
  int firstPageSize = 15;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<PlotResponseEntity> getPlotList(
    String farmerId,
    String plotName,
    String cropId,
    String startLimit,
  ) async {
    offsets.add(startLimit);
    if (fail) throw Exception('Offline');
    final offset = int.parse(startLimit);
    return PlotResponseEntity(
      status: true,
      message: '',
      result: List.generate(
        offset == 0 ? firstPageSize : (offset == 15 ? 3 : 0),
        (index) => PlotEntity(
          plotRegistrationId: '${offset + index}',
          plotName: 'Plot',
          sowingDate: '',
          cropId: '',
          cropName: '',
          farmerId: farmerId,
          farmerName: '',
          createdDate: '',
        ),
      ),
    );
  }
}

Future<void> _load(CropBloc bloc, String offset) async {
  final done = bloc.stream.firstWhere(
    (state) =>
        state.cropStatus != CropStatus.loading && !state.loadingMorePlots,
  );
  bloc.add(GetPlotListEvent(farmerId: 'farmer', startLimit: offset));
  await done;
}

void main() {
  test(
    'plots append in pages of 15, retain data on error, retry and reset',
    () async {
      final repository = _Repository();
      final bloc = CropBloc(
        cropScheduleUsecases: CropScheduleUsecases(repository),
      );
      addTearDown(bloc.close);
      await _load(bloc, '0');
      expect(bloc.state.plotLits.length, 15);
      expect(bloc.state.nextPlotOffset, 15);
      expect(bloc.state.hasMorePlots, isTrue);
      repository.fail = true;
      await _load(bloc, '15');
      expect(bloc.state.plotLits.length, 15);
      expect(bloc.state.nextPlotOffset, 15);
      expect(bloc.state.plotPaginationError, isNotNull);
      repository.fail = false;
      await _load(bloc, '15');
      expect(bloc.state.plotLits.length, 18);
      expect(bloc.state.nextPlotOffset, 30);
      expect(bloc.state.hasMorePlots, isTrue);
      expect(bloc.state.plotPaginationError, isNull);
      await _load(bloc, '30');
      expect(bloc.state.hasMorePlots, isFalse);
      expect(bloc.state.plotLits.length, 18);
      bloc.add(const GetPlotListEvent(farmerId: 'farmer', startLimit: '45'));
      await Future<void>.delayed(Duration.zero);
      expect(repository.offsets, ['0', '15', '15', '30']);
      await _load(bloc, '0');
      expect(bloc.state.plotLits.length, 15);
      expect(bloc.state.nextPlotOffset, 15);
      expect(bloc.state.hasMorePlots, isTrue);
      expect(repository.offsets, ['0', '15', '15', '30', '0']);
    },
  );
  test('short first page still permits the next offset', () async {
    final repository = _Repository()..firstPageSize = 10;
    final bloc = CropBloc(cropScheduleUsecases: CropScheduleUsecases(repository));
    addTearDown(bloc.close);
    await _load(bloc, '0');
    expect(bloc.state.hasMorePlots, isTrue);
    await _load(bloc, '15');
    expect(repository.offsets, ['0', '15']);
    expect(bloc.state.plotLits.length, 13);
  });
}
