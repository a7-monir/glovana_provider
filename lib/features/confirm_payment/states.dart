part of 'bloc.dart';

class ConfirmPaymentStates {}

class ConfirmPaymentLoadingState extends ConfirmPaymentStates {}

class ConfirmPaymentFailedState extends ConfirmPaymentStates {
  final CustomResponse response;

  ConfirmPaymentFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}

class ConfirmPaymentSuccessState extends ConfirmPaymentStates {
  final String msg;

  ConfirmPaymentSuccessState({required this.msg});
}
