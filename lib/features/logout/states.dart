part of 'bloc.dart';

class SignOutStates {}

class SignOutLoadingState extends SignOutStates {}

class SignOutSuccessState extends SignOutStates {}

class SignOutFailedState extends SignOutStates {
  final String msg;

  SignOutFailedState({required this.msg}) {
    Navigator.pop(navigatorKey.currentContext!);
    showMessage(msg);
  }
}
