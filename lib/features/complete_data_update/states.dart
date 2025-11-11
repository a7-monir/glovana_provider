part of 'bloc.dart';

class CompleteDataStates {}

class CompleteDataLoadingState extends CompleteDataStates {}

class CompleteDataFailedState extends CompleteDataStates {
  final String msg;
  final int? statusCode;

  CompleteDataFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class CompleteDataSuccessState extends CompleteDataStates {

}
