import 'package:dio/dio.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/repository/crop_repository.dart';
import 'package:farmer_consultant/features/crop_schedule/domain/usecase/crop_schedule_usecases.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_bloc.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_event.dart';
import 'package:farmer_consultant/features/crop_schedule/presentation/bloc/crop_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements CropRepository {
  List<String>? arguments;
  bool fail = false;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<Response> addPlotFinance(
    String date,
    String amount,
    String remark,
    String farmerId,
    String plotId,
    String type,
  ) async {
    arguments = [date, amount, remark, farmerId, plotId, type];
    if (fail) throw Exception('Offline');
    return Response(
      requestOptions: RequestOptions(),
      data: {'status': true, 'message': 'Saved'},
    );
  }
}

void main() {
  for (final type in ['Income', 'Expense']) {
    test(
      '$type save reaches repository and completes; failure allows retry',
      () async {
        final repository = _Repository();
        final bloc = CropBloc(
          cropScheduleUsecases: CropScheduleUsecases(repository),
        );
        addTearDown(bloc.close);
        final event = AddPlotFinanceEvent(
          date: '29-10-2026',
          amount: '123.45',
          remark: 'Example',
          farmerId: 'farmer',
          plotId: 'plot',
          type: type,
        );

        Future<void> save(CropStatus expected) async {
          final result = expectLater(
            bloc.stream.map((state) => state.cropStatus),
            emitsInOrder([CropStatus.loading, expected]),
          );
          bloc.add(event);
          await result;
        }

        await save(CropStatus.success);
        expect(repository.arguments, [
          '29-10-2026',
          '123.45',
          'Example',
          'farmer',
          'plot',
          type,
        ]);
        repository.fail = true;
        await save(CropStatus.failure);
        repository.fail = false;
        await save(CropStatus.success);
      },
    );
  }
}
