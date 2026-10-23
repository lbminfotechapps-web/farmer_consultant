
import 'package:farmer_consultant/features/crop_schedule/domain/entity/schedule_response_entity.dart';



class ScheduleResponseModel extends ScheduleResponseEntity {
  const ScheduleResponseModel({
    required super.status,
    required super.message,
    required List<ScheduleModel> result,
  }) : super(result: result);

  factory ScheduleResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final resultJson = json['result'];

    return ScheduleResponseModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      result: resultJson is List
          ? resultJson
              .whereType<Map>()
              .map(
                (item) => ScheduleModel.fromJson(
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
      'result': result.map((item) {
        return ScheduleModel(
          status: item.status,
          scheduleId: item.scheduleId,
          plotRegistrationId: item.plotRegistrationId,
          scheduleDate: item.scheduleDate,
          adminName: item.adminName,
          farmerName: item.farmerName,
          cropId: item.cropId,
          cropName: item.cropName,
          plotName: item.plotName,
          details: item.details.map((detail) {
            return ScheduleDetailModel(
              remark: detail.remark,
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

class ScheduleDetailModel extends ScheduleDetailEntity {
  const ScheduleDetailModel({
    super.remark,
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

  factory ScheduleDetailModel.fromJson(Map<String, dynamic> json) {
    return ScheduleDetailModel(
      remark: json['fld_remark']?.toString() ?? '',
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
      'fld_remark': remark,
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



class ScheduleModel extends ScheduleEntity {
  const ScheduleModel({
    super.status,
    required super.scheduleId,
    required super.plotRegistrationId,
    required super.scheduleDate,
    required super.adminName,
    required super.farmerName,
    required super.cropId,
    required super.cropName,
    required super.plotName,
    required List<ScheduleDetailModel> details,
  }) : super(details: details);

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    final detailsJson = json['details'];

    return ScheduleModel(
      status: json['fld_status']?.toString() ?? '',
      scheduleId: json['fld_schedule_id']?.toString() ?? '',
      plotRegistrationId:
          json['fld_plot_registration_id']?.toString() ?? '',
      scheduleDate: json['fld_schedule_date']?.toString() ?? '',
      adminName: json['fld_adm_name']?.toString() ?? '',
      farmerName: json['fld_farmer_name']?.toString() ?? '',
      cropId: json['fld_crop_id']?.toString() ?? '',
      cropName: json['fld_crop_name']?.toString() ?? '',
      plotName: json['fld_plot_name']?.toString() ?? '',
      details: detailsJson is List
          ? detailsJson
              .whereType<Map>()
              .map(
                (item) => ScheduleDetailModel.fromJson(
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
      'fld_status': status,
      'fld_schedule_date': scheduleDate,
      'fld_adm_name': adminName,
      'fld_farmer_name': farmerName,
      'fld_crop_id': cropId,
      'fld_crop_name': cropName,
      'fld_plot_name': plotName,
      'details': details.map((item) {
        return ScheduleDetailModel(
          remark: item.remark,
          scheduleDetailId: item.scheduleDetailId,
          scheduleId: item.scheduleId,
          productName: item.productName,
          cropId: item.cropId,
          cropName: item.cropName,
          productType: item.productType,
          productQty: item.productQty,
          unit: item.unit,
          waterQty: item.waterQty,
          waterUnit: item.waterUnit,
        ).toJson();
      }).toList(),
    };
  }
}
