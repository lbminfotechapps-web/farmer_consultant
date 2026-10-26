import 'package:equatable/equatable.dart';

abstract class DealerEevent extends Equatable {
  const DealerEevent();

  @override
  List<Object?> get props => [];
}

class DealerListEvent extends DealerEevent {
  final String farmerId;
  final String latitude;
  final String longitude;

  const DealerListEvent({
    required this.farmerId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [farmerId, latitude, longitude];
}
