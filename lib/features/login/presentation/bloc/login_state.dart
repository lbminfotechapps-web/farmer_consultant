import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';

enum LoginStatus { initial, sendOtploading, success, failure, loginloading }

class LoginState {
  final LoginStatus loginStatus;
  final String? errorMessage;
  final String? otp;
  final LoginEntity? loginModel;

  const LoginState({
    this.loginStatus = LoginStatus.initial,
    this.errorMessage,
    this.otp,
    this.loginModel,
  });

  LoginState copyWith({
    LoginStatus? loginStatus,
    String? errorMessage,
    String? otp,
    bool clearOtp = false,
    LoginEntity? loginModel,
    bool clearLoginModel = false,
  }) {
    return LoginState(
      loginStatus: loginStatus ?? this.loginStatus,
      errorMessage: errorMessage,
      otp: clearOtp ? null : (otp ?? this.otp),
      loginModel: clearLoginModel ? null : (loginModel ?? this.loginModel),
    );
  }
}
