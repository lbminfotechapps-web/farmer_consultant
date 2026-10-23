import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';
import 'package:farmer_consultant/features/login/domain/repository/login_repository.dart';
import 'package:farmer_consultant/features/login/domain/usecase/login_usecase.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_bloc.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_event.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_state.dart';
import 'package:flutter_test/flutter_test.dart';

const farmer = LoginEntity(
  status: true,
  message: 'Success',
  farmerId: '1',
  farmerName: 'Farmer',
  mobileNo: '8888855556',
  address: '',
);

class FakeLoginRepository implements LoginRepository {
  @override
  Future<String> getOtp(String mobileNo) async => '1234';

  @override
  Future<LoginEntity> login(String mobileNo, String otp) async => farmer;
}

void main() {
  test('login result survives state updates and can be reset', () {
    final state = LoginState(loginModel: farmer);
    expect(
      state.copyWith(loginStatus: LoginStatus.loginloading).loginModel,
      farmer,
    );
    expect(state.copyWith(clearLoginModel: true).loginModel, isNull);
  });

  test('successful verification clears OTP and retains farmer', () async {
    final bloc = LoginBloc(LoginUsecase(FakeLoginRepository()));
    addTearDown(bloc.close);
    final statuses = <LoginStatus>[];
    final subscription = bloc.stream.listen((state) {
      statuses.add(state.loginStatus);
    });
    addTearDown(subscription.cancel);
    final otpReady = bloc.stream.firstWhere((s) => s.otp != null);
    bloc.add(GetOtpEvent('8888855556'));
    await otpReady;
    final loggedIn = bloc.stream.firstWhere((s) => s.loginModel != null);
    bloc.add(FarmerLoginEvent('8888855556', '1234'));
    final state = await loggedIn;
    expect(state.loginStatus, LoginStatus.success);
    expect(state.otp, isNull);
    expect(state.loginModel, farmer);
    expect(statuses, [
      LoginStatus.sendOtploading,
      LoginStatus.success,
      LoginStatus.loginloading,
      LoginStatus.success,
    ]);
  });
}
