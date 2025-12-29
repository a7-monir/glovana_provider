part of 'bloc.dart';

class GetPendingPaymentStates {}

class GetPendingPaymentLoadingState extends GetPendingPaymentStates {}

class GetPendingPaymentFailedState extends GetPendingPaymentStates {
  final CustomResponse response;

  GetPendingPaymentFailedState({required this.response});
}

class GetPendingPaymentSuccessState extends GetPendingPaymentStates {
  final List<Appointment> list;

  GetPendingPaymentSuccessState({required this.list});
}
