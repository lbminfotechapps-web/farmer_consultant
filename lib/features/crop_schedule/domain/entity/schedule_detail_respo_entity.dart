import 'package:equatable/equatable.dart';

class ScheduleByPlotResponseEntity extends Equatable {
  final bool status;
  final String message;
  final List<ScheduleByPlotEntity> result;

  const ScheduleByPlotResponseEntity({
    required this.status,
    required this.message,
    required this.result,
  });

  @override
  List<Object?> get props => [status, message, result];
}

class ScheduleDetailByPlotEntity extends Equatable {
  final String scheduleDetailId;
  final String scheduleId;
  final String productName;
  final String cropId;
  final String cropName;
  final String productType;
  final String productQty;
  final String unit;
  final String waterQty;
  final String waterUnit;
  final String remark;

  const ScheduleDetailByPlotEntity({
    required this.scheduleDetailId,
    required this.scheduleId,
    required this.productName,
    required this.cropId,
    required this.cropName,
    required this.productType,
    required this.productQty,
    required this.unit,
    required this.waterQty,
    required this.waterUnit,
    required this.remark
  });

  @override
  List<Object?> get props => [
    scheduleDetailId,
    scheduleId,
    productName,
    cropId,
    cropName,
    productType,
    productQty,
    unit,
    waterQty,
    waterUnit,
    remark
  ];
}

class ScheduleByPlotEntity extends Equatable {
  final String scheduleId;
  final String plotRegistrationId;
  final String scheduleDate;
  final String adminName;
  final String farmerName;
  final String cropId;
  final String cropName;
  final String plotName;
  final String remark;
   final String status;
  final List<ScheduleDetailByPlotEntity> details;

  const ScheduleByPlotEntity({
    required this.scheduleId,
    required this.plotRegistrationId,
    required this.scheduleDate,
    required this.adminName,
    required this.farmerName,
    required this.cropId,
    required this.cropName,
    required this.plotName,
    required this.remark,
    required this.status,
    required this.details,

  });

  @override
  List<Object?> get props => [
    scheduleId,
    plotRegistrationId,
    scheduleDate,
    adminName,
    farmerName,
    cropId,
    cropName,
    plotName,
    details,
    remark,
    status
  ];
}
