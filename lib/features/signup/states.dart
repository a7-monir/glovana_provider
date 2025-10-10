part of 'bloc.dart';

class SignupStates {}

class SignupLoadingState extends SignupStates {}

class SignupFailedState extends SignupStates {
  final String msg;
  final int? statusCode;

  SignupFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class SignupSuccessState extends SignupStates {
  final String msg;

  SignupSuccessState({required this.msg});
}
