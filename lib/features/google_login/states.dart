part of 'bloc.dart';

class SocialLoginStates {}

class SocialLoginLoadingState extends SocialLoginStates {}

class SocialLoginFailedState extends SocialLoginStates {
  final String msg;
  final int? statusCode;

  SocialLoginFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class SocialLoginSuccessState extends SocialLoginStates {
  final String msg;

  SocialLoginSuccessState({required this.msg});
}
