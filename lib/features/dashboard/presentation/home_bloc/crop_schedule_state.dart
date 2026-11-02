import 'package:equatable/equatable.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/crop_schedule.dart';
import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';

enum CropScheduleStatus { initial, loading, success, failure }

class CropScheduleState extends Equatable {
  final CropScheduleStatus status;
  final List<CropSchedule> schedules;
  final SuccessStoryEntity? successStoryEntity;
  final String? errorMessage;

  const CropScheduleState({
    this.status = CropScheduleStatus.initial,
    this.schedules = const [],
    this.errorMessage,
    this.successStoryEntity,
  });

  CropScheduleState copyWith({
    CropScheduleStatus? status,
    List<CropSchedule>? schedules,
    String? errorMessage,
    SuccessStoryEntity? successStoryEntity,
    bool clearErrorMessage = false,
  }) {
    return CropScheduleState(
      status: status ?? this.status,
      schedules: schedules ?? this.schedules,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      successStoryEntity: successStoryEntity ?? this.successStoryEntity,
    );
  }

  @override
  List<Object?> get props => [
    status,
    schedules,
    errorMessage,
    successStoryEntity,
  ];
}
