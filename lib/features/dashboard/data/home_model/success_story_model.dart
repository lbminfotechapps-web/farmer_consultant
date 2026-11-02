import 'package:farmer_consultant/features/dashboard/doman/home_entity/success_story_entity.dart';

class SuccessStoryModel extends SuccessStoryEntity {
  const SuccessStoryModel({
    required super.status,
    required super.result,
    required super.message,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      status: _toBool(json['status']),
      result: json['result'] is List
          ? (json['result'] as List)
                .whereType<Map>()
                .map(
                  (item) => SuccessStoryItemModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : <SuccessStoryItemModel>[],
      message: _toString(json['message']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'result': result.map((item) {
        if (item is SuccessStoryItemModel) {
          return item.toJson();
        }

        return SuccessStoryItemModel(
          farmerId: item.farmerId,
          farmerName: item.farmerName,
          mobileNo: item.mobileNo,
          alternateMobileNo: item.alternateMobileNo,
          address: item.address,
          cropIds: item.cropIds,
          cropAcreage: item.cropAcreage,
          usedProduct: item.usedProduct,
          cropStage: item.cropStage,
          employeeNameHq: item.employeeNameHq,
          successVideo: item.successVideo,
          createdDate: item.createdDate,
          videoUrl: item.videoUrl,
          cropNames: item.cropNames,
        ).toJson();
      }).toList(),
      'message': message,
    };
  }
}

class SuccessStoryItemModel extends SuccessStoryItemEntity {
  const SuccessStoryItemModel({
    required super.farmerId,
    required super.farmerName,
    required super.mobileNo,
    required super.alternateMobileNo,
    required super.address,
    required super.cropIds,
    required super.cropAcreage,
    required super.usedProduct,
    required super.cropStage,
    required super.employeeNameHq,
    required super.successVideo,
    required super.createdDate,
    required super.videoUrl,
    required super.cropNames,
  });

  factory SuccessStoryItemModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryItemModel(
      farmerId: _toString(json['fld_farmer_id']),
      farmerName: _toString(json['fld_farmer_name']),
      mobileNo: _toString(json['fld_mobile_no']),
      alternateMobileNo: _toString(json['fld_alternate_mobileno']),
      address: _toString(json['fld_address']),
      cropIds: _toString(json['fld_crop_ids']),
      cropAcreage: _toString(json['fld_crop_acrage']),
      usedProduct: _toString(json['fld_used_product']),
      cropStage: _toString(json['fld_crop_stage']),
      employeeNameHq: _toString(json['fld_employeename_hq']),
      successVideo: _toString(json['fld_success_video']),
      createdDate: _toString(json['fld_created_date']),
      videoUrl: _toString(
        json['video_url'] ?? '',
      ), // Default to an empty string if not provided
      cropNames: _readCropNames(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fld_farmer_id': farmerId,
      'fld_farmer_name': farmerName,
      'fld_mobile_no': mobileNo,
      'fld_alternate_mobileno': alternateMobileNo,
      'fld_address': address,
      'fld_crop_ids': cropIds,
      'fld_crop_acrage': cropAcreage,
      'fld_used_product': usedProduct,
      'fld_crop_stage': cropStage,
      'fld_employeename_hq': employeeNameHq,
      'fld_success_video': successVideo,
      'fld_created_date': createdDate,
      'video_url': videoUrl,
      'fld_crop_names': cropNames,
    };
  }
}

// ============================================================
// SAFE JSON CONVERSION HELPERS
// ============================================================

String _toString(dynamic value) {
  return value?.toString() ?? '';
}

String _readCropNames(Map<String, dynamic> json) {
  // Responses may use the same fld_ prefix as the other story fields.
  for (final key in [
    'crop_names',
    'fld_crop_names',
    'crop_name',
    'fld_crop_name',
  ]) {
    final value = json[key];
    final names = value is List
        ? value.whereType<String>().join(', ')
        : value is String
        ? value
        : '';
    if (names.trim().isNotEmpty) return names.trim();
  }
  return '';
}

bool _toBool(dynamic value) {
  if (value is bool) return value;

  if (value is num) return value == 1;

  final text = value?.toString().trim().toLowerCase();

  return text == 'true' || text == '1';
}
