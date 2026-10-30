import 'package:equatable/equatable.dart';

abstract class CropEvent extends Equatable {
  const CropEvent();

  @override
  List<Object?> get props => [];
}

class GetCropScheduleEvent extends CropEvent {
  final String farmerId;
  final String? fromDate;
  final String? toDate;

  const GetCropScheduleEvent(this.farmerId, {this.fromDate, this.toDate});

  @override
  List<Object?> get props => [farmerId, fromDate, toDate];
}

class GetAvailableDatesEvent extends CropEvent {
  final String farmerId;

  const GetAvailableDatesEvent(this.farmerId);

  @override
  List<Object?> get props => [farmerId];
}

class GetPlotListEvent extends CropEvent {
  final String farmerId;
  final String? plotName;
  final String? cropId;
  final String? startLimit;

  const GetPlotListEvent({
    required this.farmerId,
    this.plotName,
    this.cropId,
    this.startLimit,
  });

  @override
  List<Object?> get props => [farmerId, plotName, cropId, startLimit];
}

class GetCropScheduleByPlotListEvent extends CropEvent {
  final String farmerId;
  final String plotId;
  final String? cropId;
  final String? fromDate;
  final String? toDate;
  final String? startLimit;

  const GetCropScheduleByPlotListEvent(
    this.farmerId,
    this.plotId, {
    this.cropId,
    this.fromDate,
    this.toDate,
    this.startLimit,
  });

  @override
  List<Object?> get props => [
    farmerId,
    plotId,
    cropId,
    fromDate,
    toDate,
    startLimit,
  ];
}

class UpdateScheduleStatus extends CropEvent {
  final String farmerId;
  final String scheduleId;

  const UpdateScheduleStatus({
    required this.farmerId,
    required this.scheduleId,
  });

  @override
  List<Object?> get props => [farmerId, scheduleId];
}

class AddPlotFinanceEvent extends CropEvent {
  final String date;
  final String amount;
  final String remark;
  final String farmerId;
  final String plotId;
  final String type;

  const AddPlotFinanceEvent({
    required this.date,
    required this.amount,
    required this.remark,
    required this.farmerId,
    required this.plotId,
    required this.type,
  });

  @override
  List<Object?> get props => [date, amount, remark, farmerId, plotId, type];
}

class GetPlotFinanceEvent extends CropEvent {
  final String farmerId;
  final String plotId;
  final String type;

  const GetPlotFinanceEvent({
    required this.farmerId,
    required this.plotId,
    required this.type,
  });

  @override
  List<Object?> get props => [farmerId, plotId, type];
}

class DeletePlotFinanceEvent extends CropEvent {
  final String farmerId;
  final String financeId;

  const DeletePlotFinanceEvent({
    required this.farmerId,
    required this.financeId,
  });

  @override
  List<Object?> get props => [farmerId, financeId];
}
