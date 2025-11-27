part of 'bloc.dart';

class CompleteDataUpdateStates {}

class CompleteDataUpdateLoadingState extends CompleteDataUpdateStates {}

class CompleteDataUpdateFailedState extends CompleteDataUpdateStates {
  final String msg;
  final int? statusCode;

  CompleteDataUpdateFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class CompleteDataUpdateSuccessState extends CompleteDataUpdateStates {
  final String msg;

  CompleteDataUpdateSuccessState({required this.msg});
}
