class LoginEntity {
  final bool status;
  final String message;
  final String farmerId;
  final String farmerName;
  final String mobileNo;
  final String address;
  final String taluka;
  final String state;

  const LoginEntity({
    required this.status,
    required this.message,
    required this.farmerId,
    required this.farmerName,
    required this.mobileNo,
    required this.address,
    required this.taluka,
    required this.state,
  });

  // Parse complete login API response
  factory LoginEntity.fromJson(Map<String, dynamic> json) {
    final result = json['result'] is Map
        ? Map<String, dynamic>.from(json['result'])
        : <String, dynamic>{};

    return LoginEntity(
      status:
          json['status'] == true ||
          json['status']?.toString().toLowerCase() == 'true',

      message: json['message']?.toString() ?? '',

      farmerId: result['fld_farmer_id']?.toString() ?? '',

      farmerName: result['fld_farmer_name']?.toString() ?? '',

      mobileNo: result['fld_mobile_no']?.toString() ?? '',

      address: result['fld_address']?.toString() ?? '',
      taluka: result['taluka_name']?.toString() ?? '',
      state: result['state_name']?.toString() ?? '',
    );
  }

  // Convert entity to JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'result': {
        'fld_farmer_id': farmerId,
        'fld_farmer_name': farmerName,
        'fld_mobile_no': mobileNo,
        'fld_address': address,
        'taluka_name':taluka,
        'state_name':state
      },
    };
  }

  // Optional: create updated copy
  LoginEntity copyWith({
    bool? status,
    String? message,
    String? farmerId,
    String? farmerName,
    String? mobileNo,
    String? address,
    String? taluka,
     String? state,
  }) {
    return LoginEntity(
      status: status ?? this.status,
      message: message ?? this.message,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      mobileNo: mobileNo ?? this.mobileNo,
      address: address ?? this.address,
      taluka: taluka??this.taluka,
      state: state??this.state
    );
  }
}
