import 'package:farmer_consultant/features/dealer/data/model/DealerListModel.dart';
import 'package:farmer_consultant/features/dealer/domain/repository/dealer_repo.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_bloc.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_event.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _RetryRepository implements DealerListRepository {
  int calls = 0;

  @override
  Future<List<DealerListModel>> getDealers(
    String farmerId,
    String latitude,
    String longitude,
  ) async {
    calls++;
    if (calls == 1) throw Exception('Connection failed');
    return const [
      DealerListModel(
        outletId: '1',
        outletName: 'Nearby dealer',
        outletPerson: 'Contact',
        outletAddress: 'Address',
      ),
    ];
  }
}

void main() {
  test(
    'retry after failure fetches dealers and clears the old error',
    () async {
      final repository = _RetryRepository();
      final bloc = DealerListBloc(repository: repository);
      addTearDown(bloc.close);
      const event = DealerListEvent(
        farmerId: '12',
        latitude: '18.5',
        longitude: '73.8',
      );

      final failed = bloc.stream.firstWhere(
        (state) => state.status == DealerListStatus.failure,
      );
      bloc.add(event);
      expect((await failed).errorMessage, contains('Connection failed'));

      final states = <DealerListState>[];
      final subscription = bloc.stream.listen(states.add);
      addTearDown(subscription.cancel);
      final loaded = bloc.stream.firstWhere(
        (state) => state.status == DealerListStatus.success,
      );
      bloc.add(event);
      final result = await loaded;

      expect(repository.calls, 2);
      expect(states.first.status, DealerListStatus.loading);
      expect(states.first.errorMessage, isNull);
      expect(result.dealerList.single.outletName, 'Nearby dealer');
      expect(result.errorMessage, isNull);
    },
  );
}
