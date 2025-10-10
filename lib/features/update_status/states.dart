part of 'bloc.dart';

class UpdateStatusStates {}

class UpdateStatusLoadingState extends UpdateStatusStates {}

class UpdateStatusFailedState extends UpdateStatusStates {
  final CustomResponse response;

  UpdateStatusFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}

class UpdateStatusSuccessState extends UpdateStatusStates {
}
