part of 'bloc.dart';

class ConvertPointsStates {}

class ConvertPointsLoadingState extends ConvertPointsStates {}

class ConvertPointsFailedState extends ConvertPointsStates {
  final CustomResponse response;

  ConvertPointsFailedState({required this.response}) {
    showMessage(response.msg);
  }
}

class ConvertPointsSuccessState extends ConvertPointsStates {
  final String msg;

  ConvertPointsSuccessState({required this.msg});
}
