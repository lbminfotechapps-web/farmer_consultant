import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/features/login/data/datasource/auth_datasource.dart';
import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';
import 'package:farmer_consultant/features/login/domain/repository/login_repository.dart';


class LoginRepoImp implements LoginRepository {
  final LoginRemoteDataSource loginRemoteDataSource;
  final SecureStorage secureStorage;

  LoginRepoImp(
    this.loginRemoteDataSource,
    this.secureStorage,
  );

  @override
  Future<String> getOtp(String mobileNo) {
    return loginRemoteDataSource.getOtp(mobileNo);
  }

  @override
  Future<LoginEntity> login(
    String mobileNo,
    String otp,
  ) async {
    // Call login API
    final LoginEntity response =
        await loginRemoteDataSource.login(
      mobileNo: mobileNo,
      otp: otp,
    );

    // Save user information only if login is successful
    if (response.status && response.farmerId.isNotEmpty) {
      await secureStorage.saveUserData({
        'fld_farmer_id': response.farmerId,
        'fld_farmer_name': response.farmerName,
        'fld_mobile_no': response.mobileNo,
        'fld_address': response.address,
      });
    }

    // Return login response to BLoC
    return response;
  }
}
