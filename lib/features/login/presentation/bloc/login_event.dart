import 'package:equatable/equatable.dart';

class LoginEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetOtpEvent extends LoginEvent {
  final String mobileNo;

  GetOtpEvent(this.mobileNo);
  @override
  List<Object> get props => [mobileNo];
}

class FarmerLoginEvent extends LoginEvent {
  final String mobileNo;
  final String otp;

  FarmerLoginEvent(this.mobileNo, this.otp);
  @override
  List<Object> get props => [mobileNo, otp];
}
