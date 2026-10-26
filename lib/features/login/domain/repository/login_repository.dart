import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';

abstract class LoginRepository {
  Future<String> getOtp(String mobileNo);

  Future<LoginEntity> login(
    String mobileNo,
    String otp,
    String fcmId,
    String macAddress,
  );
}
