part of 'bloc.dart';

class SendOtpStates {}

class SendOtpLoadingState extends SendOtpStates {}

class SendOtpFailedState extends SendOtpStates {
  final String msg;

  SendOtpFailedState({required this.msg,});
}

class SendOtpSuccessState extends SendOtpStates {
  final String otp;

  SendOtpSuccessState({required this.otp});
}
