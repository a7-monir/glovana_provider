part of 'bloc.dart';

class VerifyOtpEvents {}

class VerifyOtpEvent extends VerifyOtpEvents {
  final String otp;

  VerifyOtpEvent({required this.otp});
}
