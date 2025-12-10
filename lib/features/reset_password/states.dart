part of 'bloc.dart';

class ResetPasswordStates {}

class ResetPasswordLoadingState extends ResetPasswordStates {}

class ResetPasswordFailedState extends ResetPasswordStates {
  final String msg;
  final int? statusCode;

  ResetPasswordFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class ResetPasswordSuccessState extends ResetPasswordStates {
  final String msg;

  ResetPasswordSuccessState({required this.msg}){
    showMessage(msg);
  }
}
