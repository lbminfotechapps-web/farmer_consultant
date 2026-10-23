import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_detail_respo_entity.dart';

class ScheduleByPlotResponseModel extends ScheduleByPlotResponseEntity {
  const ScheduleByPlotResponseModel({
    required super.status,
    required super.message,
    required List<ScheduleByPlotModel> result,
  }) : super(result: result);

  factory ScheduleByPlotResponseModel.fromJson(Map<String, dynamic> json) {
    final resultData = json['result'];

    return ScheduleByPlotResponseModel(
      status:
          json['status'] == true ||
          json['status']?.toString().toLowerCase() == 'true',
      message: json['message']?.toString() ?? '',
      result: resultData is List
          ? resultData
                .whereType<Map>()
                .map(
                  (item) => ScheduleByPlotModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result.map((schedule) {
        return ScheduleByPlotModel(
          scheduleId: schedule.scheduleId,
          plotRegistrationId: schedule.plotRegistrationId,
          scheduleDate: schedule.scheduleDate,
          adminName: schedule.adminName,
          farmerName: schedule.farmerName,
          cropId: schedule.cropId,
          cropName: schedule.cropName,
          plotName: schedule.plotName,
          remark: schedule.remark,
          status: schedule.status,
          details: schedule.details.map((detail) {
            return ScheduleDetailByPlotModel(
              scheduleDetailId: detail.scheduleDetailId,
              scheduleId: detail.scheduleId,
              productName: detail.productName,
              cropId: detail.cropId,
              cropName: detail.cropName,
              productType: detail.productType,
              productQty: detail.productQty,
              unit: detail.unit,
              waterQty: detail.waterQty,
              waterUnit: detail.waterUnit,
            );
          }).toList(),
        ).toJson();
      }).toList(),
    };
  }
}

class ScheduleDetailByPlotModel extends ScheduleDetailByPlotEntity {
  const ScheduleDetailByPlotModel({
    required super.scheduleDetailId,
    required super.scheduleId,
    required super.productName,
    required super.cropId,
    required super.cropName,
    required super.productType,
    required super.productQty,
    required super.unit,
    required super.waterQty,
    required super.waterUnit,
  });

  factory ScheduleDetailByPlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDetailByPlotModel(
      scheduleDetailId: json['fld_schedule_det_id']?.toString() ?? '',
      scheduleId: json['fld_schedule_id']?.toString() ?? '',
      productName: json['fld_product_name']?.toString() ?? '',
      cropId: json['fld_crop_id']?.toString() ?? '',
      cropName: json['fld_crop_name']?.toString() ?? '',
      productType: json['fld_product_type']?.toString() ?? '',
      productQty: json['fld_product_qty']?.toString() ?? '',
      unit: json['fld_unit']?.toString() ?? '',
      waterQty: json['fld_water_qty']?.toString() ?? '',
      waterUnit: json['fld_water_unit']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fld_schedule_det_id': scheduleDetailId,
      'fld_schedule_id': scheduleId,
      'fld_product_name': productName,
      'fld_crop_id': cropId,
      'fld_crop_name': cropName,
      'fld_product_type': productType,
      'fld_product_qty': productQty,
      'fld_unit': unit,
      'fld_water_qty': waterQty,
      'fld_water_unit': waterUnit,
    };
  }
}

class ScheduleByPlotModel extends ScheduleByPlotEntity {
  const ScheduleByPlotModel({
    required super.scheduleId,
    required super.plotRegistrationId,
    required super.scheduleDate,
    required super.adminName,
    required super.farmerName,
    required super.cropId,
    required super.cropName,
    required super.plotName,
    required super.remark,
    required super.status,
    required List<ScheduleDetailByPlotModel> super.details,
  });

  factory ScheduleByPlotModel.fromJson(Map<String, dynamic> json) {
    final detailsData = json['details'];

    return ScheduleByPlotModel(
      scheduleId: json['fld_schedule_id']?.toString() ?? '',
      plotRegistrationId: json['fld_plot_registration_id']?.toString() ?? '',
      scheduleDate: json['fld_schedule_date']?.toString() ?? '',
      adminName: json['fld_adm_name']?.toString() ?? '',
      farmerName: json['fld_farmer_name']?.toString() ?? '',
      cropId: json['fld_crop_id']?.toString() ?? '',
      cropName: json['fld_crop_name']?.toString() ?? '',
      plotName: json['fld_plot_name']?.toString() ?? '',
      remark: json['fld_remark']?.toString() ?? '',
      status: json['fld_status']?.toString() ?? '',
      details: detailsData is List
          ? detailsData
                .whereType<Map>()
                .map(
                  (item) => ScheduleDetailByPlotModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fld_schedule_id': scheduleId,
      'fld_plot_registration_id': plotRegistrationId,
      'fld_schedule_date': scheduleDate,
      'fld_adm_name': adminName,
      'fld_farmer_name': farmerName,
      'fld_crop_id': cropId,
      'fld_crop_name': cropName,
      'fld_plot_name': plotName,
      'fld_remark': remark,
      'fld_status': status,
      'details': details.map((detail) {
        return ScheduleDetailByPlotModel(
          scheduleDetailId: detail.scheduleDetailId,
          scheduleId: detail.scheduleId,
          productName: detail.productName,
          cropId: detail.cropId,
          cropName: detail.cropName,
          productType: detail.productType,
          productQty: detail.productQty,
          unit: detail.unit,
          waterQty: detail.waterQty,
          waterUnit: detail.waterUnit,
        ).toJson();
      }).toList(),
    };
  }
}
