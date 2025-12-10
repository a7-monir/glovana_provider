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
  final String msg,token;
  final User model;

  LoginSuccessState({required this.msg, required this.token, required this.model});



}
