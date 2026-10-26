import 'dart:async';

import 'package:farmer_consultant/features/login/domain/entity/login_entity.dart';
import 'package:farmer_consultant/features/login/domain/usecase/login_usecase.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_event.dart';
import 'package:farmer_consultant/features/login/presentation/bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc(this.loginUsecase) : super(const LoginState()) {
    on<GetOtpEvent>(_onGetOtp);
    on<FarmerLoginEvent>(_onFarmerLogin);
  }

  Future<void> _onGetOtp(GetOtpEvent event, Emitter<LoginState> emit) async {
    // Start loader.
    emit(
      state.copyWith(
        loginStatus: LoginStatus.sendOtploading,
        errorMessage: null,
        clearOtp: true,
        clearLoginModel: true,
      ),
    );

    try {
      final mobileNo = event.mobileNo.trim();

      if (!RegExp(r'^[0-9]{10}$').hasMatch(mobileNo)) {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.failure,
            errorMessage: 'Enter a valid 10-digit mobile number',
          ),
        );
        return;
      }

      final String otp = await loginUsecase.getOtp(mobileNo);

      // Stop loader and notify LoginScreen.
      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
          otp: otp,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
          clearOtp: true,
        ),
      );
    }
  }

  Future<void> _onFarmerLogin(
    FarmerLoginEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(
      state.copyWith(
        loginStatus: LoginStatus.loginloading,
        errorMessage: null,
        clearOtp: true,
        clearLoginModel: true,
      ),
    );

    try {
      final mobileNo = event.mobileNo.trim();
      final otp = event.otp.trim();

      if (!RegExp(r'^[0-9]{10}$').hasMatch(mobileNo) ||
          !RegExp(r'^[0-9]{4}$').hasMatch(otp)) {
        throw Exception('Enter a valid mobile number and 4-digit OTP');
      }
      final LoginEntity response = await loginUsecase.login(
        mobileNo,
        otp,

      );

      if (!response.status) {
        emit(
          state.copyWith(
            loginStatus: LoginStatus.failure,
            errorMessage: response.message,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          loginStatus: LoginStatus.success,
          loginModel: response,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
