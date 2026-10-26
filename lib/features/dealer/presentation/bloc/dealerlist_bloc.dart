import 'dart:async';


import 'package:farmer_consultant/features/dealer/domain/repository/dealer_repo.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_event.dart';
import 'package:farmer_consultant/features/dealer/presentation/bloc/dealerlist_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

class DealerListBloc extends Bloc<DealerEevent, DealerListState> {
  final DealerListRepository repository;

  DealerListBloc({required this.repository}) : super(const DealerListState()) {
    on<DealerListEvent>(_onLoadDealers);
  }

  Future<void> _onLoadDealers(
    DealerListEvent event,
    Emitter<DealerListState> emit,
  ) async {
    print('');
    print('========================================');
    print('DEALER BLOC EVENT RECEIVED');
    print('========================================');

    print('Farmer ID     : ${event.farmerId}');
    print('Latitude    : ${event.latitude}');
    print('Longitude   : ${event.longitude}');

    emit(state.copyWith(status: DealerListStatus.loading));

    print('DEALER BLOC STATUS: LOADING');

    try {
      final dealers = await repository.getDealers(
        event.farmerId,
        event.latitude,
        event.longitude,
      );

      print('');
      print('========================================');
      print('DEALER BLOC RESPONSE');
      print('========================================');

      print('Dealers received: ${dealers.length}');

      for (final dealer in dealers) {
        print(
          'ID: ${dealer.outletId} | '
          'Name: ${dealer.outletName} | '
          'Mobile: ${dealer.outletPersonMobile} | '
          'Distance: ${dealer.outletDistance}',
        );
      }

      emit(
        state.copyWith(status: DealerListStatus.success, dealerList: dealers),
      );

      print('DEALER BLOC STATUS: SUCCESS');
    } catch (e, stackTrace) {
      print('');
      print('========================================');
      print('DEALER BLOC ERROR');
      print('========================================');

      print('ERROR: $e');
      print('STACK: $stackTrace');

      emit(
        state.copyWith(
          status: DealerListStatus.failure,
          errorMessage: e.toString(),
        ),
      );

      print('DEALER BLOC STATUS: FAILURE');
    }
  }
}
