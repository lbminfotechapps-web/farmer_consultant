import 'package:farmer_consultant/core/notification/fcm_token_service.dart';
import 'package:farmer_consultant/core/utility/device_info_util.dart';
import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';
import 'package:farmer_consultant/features/login/domain/repository/login_repository.dart';
import 'package:flutter/material.dart';

class LoginUsecase {
  final LoginRepository loginRepository;
  final FcmTokenService fcmTokenService;
  final DeviceInfoUtil deviceInfoUtil;

  LoginUsecase(this.loginRepository, this.fcmTokenService, this.deviceInfoUtil);

  Future<String> getOtp(String mobileNo) {
    return loginRepository.getOtp(mobileNo);
  }

  Future<LoginEntity> login(String mobileNo, String otp) async {
    final String? fcmToken = await fcmTokenService.getFcmToken();

    // ==========================================================
    // DEVICE INFO
    // ==========================================================

    final deviceInfo = await deviceInfoUtil.getDeviceInfo();

    final String mobileInfo = deviceInfo['mobileInfo'] ?? '';

    final String macAddress = deviceInfo['macAddress'] ?? '';

    // ==========================================================
    // DEBUG
    // ==========================================================

    debugPrint('======================================');

    debugPrint('LOGIN REQUEST DATA');

    debugPrint('FCM TOKEN: ${fcmToken ?? 'EMPTY'}');

    debugPrint('MOBILE INFO: $mobileInfo');

    debugPrint('MAC ADDRESS: $macAddress');

    debugPrint('======================================');

    return loginRepository.login(mobileNo, otp, fcmToken ?? '', macAddress);
  }
}
