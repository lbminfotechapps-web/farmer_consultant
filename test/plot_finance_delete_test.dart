import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements CropRepository {
  List<String>? arguments;
  dynamic response = {'status': true};
  bool offline = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Response> deletePlotFinance(String financeId, String farmerId) async {
    arguments = [financeId, farmerId];
    if (offline) throw Exception('Offline');
    return Response(requestOptions: RequestOptions(), data: response);
  }
}

void main() {
  test(
    'delete preserves finance ID, handles failures, and allows retry',
    () async {
      final repository = _Repository();
      final bloc = CropBloc(
        cropScheduleUsecases: CropScheduleUsecases(repository),
      );
      addTearDown(bloc.close);
      Future<void> delete(CropStatus expected) async {
        final result = expectLater(
          bloc.stream.map((state) => state.cropStatus),
          emitsInOrder([CropStatus.loading, expected]),
        );
        bloc.add(
          const DeletePlotFinanceEvent(
            farmerId: ' farmer ',
            financeId: 'finance-001',
          ),
        );
        await result;
      }

      await delete(CropStatus.success);
      expect(repository.arguments, ['finance-001', 'farmer']);
      repository.response = {'status': false, 'message': 'Cannot delete'};
      await delete(CropStatus.failure);
      expect(bloc.state.errorMessage, 'Cannot delete');
      repository.offline = true;
      await delete(CropStatus.failure);
      repository.offline = false;
      repository.response = '{"status":true}';
      await delete(CropStatus.success);
      repository.response = 'invalid';
      await delete(CropStatus.failure);
    },
  );
}
