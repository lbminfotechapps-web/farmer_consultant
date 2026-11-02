import 'package:equatable/equatable.dart';

abstract class CropScheduleEvent extends Equatable {
  const CropScheduleEvent();

  @override
  List<Object?> get props => [];
}

///
/// Initial API call
///
class GetCropSchedulesEvent extends CropScheduleEvent {
  const GetCropSchedulesEvent();

  @override
  List<Object?> get props => [];
}

///
/// Pull-to-refresh
///
class RefreshCropSchedulesEvent extends CropScheduleEvent {
  const RefreshCropSchedulesEvent();

  @override
  List<Object?> get props => [];
}

class FarmerSuccessStoryEvent extends CropScheduleEvent {
  final String farmerId;
  final String fromDate;
  final String toDate;
  final String startLimit;

  const FarmerSuccessStoryEvent({
    required this.farmerId,
    required this.fromDate,
    required this.toDate,
    required this.startLimit,
  });
  @override
  List<Object> get props => [farmerId, fromDate, toDate, startLimit];
}

class UpdateNotificationStatusEvent extends CropScheduleEvent {
  final String farmerId;

  const UpdateNotificationStatusEvent({required this.farmerId});
  @override
  List<Object> get props => [farmerId];
}
