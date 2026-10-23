

class ScheduleResponseEntity {
  final bool status;
  final String message;
  final List<ScheduleEntity> result;

  const ScheduleResponseEntity({
    required this.status,
    required this.message,
    required this.result,
  });
}

class ScheduleDetailEntity {
  final String remark;
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

  const ScheduleDetailEntity({
    this.remark = '',
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
  });
}



class ScheduleEntity {
  final String status;
  final String scheduleId;
  final String plotRegistrationId;
  final String scheduleDate;
  final String adminName;
  final String farmerName;
  final String cropId;
  final String cropName;
  final String plotName;
  final List<ScheduleDetailEntity> details;

  const ScheduleEntity({
    this.status = '',
    required this.scheduleId,
    required this.plotRegistrationId,
    required this.scheduleDate,
    required this.adminName,
    required this.farmerName,
    required this.cropId,
    required this.cropName,
    required this.plotName,
    required this.details,
  });
}
