
import 'package:farmer_consultant/features/crop_schedule/domain/entity/available_dates_entity.dart';

class AvailableDatesModel extends AvailableDatesEntity {
  const AvailableDatesModel({
    required super.status,
    required super.message,
    required super.result,
  });

  factory AvailableDatesModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AvailableDatesModel(
      status: json['status'] == true,
      message: json['message']?.toString() ?? '',
      result: (json['result'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': result,
    };
  }
}
