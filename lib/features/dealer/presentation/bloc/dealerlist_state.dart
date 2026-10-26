import 'package:farmer_consultant/features/dealer/data/model/DealerListModel.dart';

enum DealerListStatus { initial, loading, success, failure }

class DealerListState {
  final DealerListStatus status;
  final List<DealerListModel> dealerList;
  final String? errorMessage;

  const DealerListState({
    this.status = DealerListStatus.initial,
    this.dealerList = const [],

    this.errorMessage,
  });

  DealerListState copyWith({
    DealerListStatus? status,
    List<DealerListModel>? dealerList,

    String? errorMessage,
  }) {
    return DealerListState(
      status: status ?? this.status,
      dealerList: dealerList ?? this.dealerList,

      errorMessage: errorMessage,
    );
  }
}
