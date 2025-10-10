part of 'bloc.dart';

class LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginFailedState extends LoginStates {
  final String msg;
  final int? statusCode;

  LoginFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class LoginSuccessState extends LoginStates {
  final String msg;

  LoginSuccessState({required this.msg});
}
