part of 'bloc.dart';

class VerifyOtpStates {}

class VerifyOtpLoadingState extends VerifyOtpStates {}

class VerifyOtpFailedState extends VerifyOtpStates {
  final String msg;

  VerifyOtpFailedState({required this.msg,}){
    showMessage(msg);
  }
}

class VerifyOtpSuccessState extends VerifyOtpStates {}
