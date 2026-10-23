import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';
import 'package:farmer_consultant/features/login/domain/repository/login_repository.dart';

class LoginUsecase {
  final LoginRepository loginRepository;

  LoginUsecase(this.loginRepository);

  Future<String> getOtp(String mobileNo) {
    return loginRepository.getOtp(mobileNo);
  }

  Future<LoginEntity> login(String mobileNo, String otp) {
    return loginRepository.login(mobileNo, otp);
  }
}
