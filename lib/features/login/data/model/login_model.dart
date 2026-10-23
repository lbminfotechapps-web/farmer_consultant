import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';

class LoginModel extends LoginEntity {
  const LoginModel({
    required super.status,
    required super.message,
    required super.farmerId,
    required super.farmerName,
    required super.mobileNo,
    required super.address,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'] is Map
        ? Map<String, dynamic>.from(json['result'])
        : <String, dynamic>{};

    return LoginModel(
      status:
          json['status'] == true ||
          json['status']?.toString().toLowerCase() == 'true',
      message: json['message']?.toString() ?? '',
      farmerId: result['fld_farmer_id']?.toString() ?? '',
      farmerName: result['fld_farmer_name']?.toString() ?? '',
      mobileNo: result['fld_mobile_no']?.toString() ?? '',
      address: result['fld_address']?.toString() ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': {
        'fld_farmer_id': farmerId,
        'fld_farmer_name': farmerName,
        'fld_mobile_no': mobileNo,
        'fld_address': address,
      },
    };
  }
}
