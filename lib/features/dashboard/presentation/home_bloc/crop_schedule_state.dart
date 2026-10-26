import 'package:equatable/equatable.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';

enum CropScheduleStatus { initial, loading, success, failure }

class CropScheduleState extends Equatable {
  final CropScheduleStatus status;
  final List<CropSchedule> schedules;
  final String? errorMessage;

  const CropScheduleState({
    this.status = CropScheduleStatus.initial,
    this.schedules = const [],
    this.errorMessage,
  });

  CropScheduleState copyWith({
    CropScheduleStatus? status,
    List<CropSchedule>? schedules,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CropScheduleState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, schedules, errorMessage];
}
