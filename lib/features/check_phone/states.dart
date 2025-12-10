part of 'bloc.dart';

class CheckPhoneStates {}

class CheckPhoneLoadingState extends CheckPhoneStates {}

class CheckPhoneFailedState extends CheckPhoneStates {
  final String msg;
  final int? statusCode;

  CheckPhoneFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class CheckPhoneSuccessState extends CheckPhoneStates {}
