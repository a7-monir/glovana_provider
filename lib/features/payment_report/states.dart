part of 'bloc.dart';

class GetPaymentReportStates {}

class GetPaymentReportLoadingState extends GetPaymentReportStates {}

class GetPaymentReportFailedState extends GetPaymentReportStates {
  final CustomResponse response;

  GetPaymentReportFailedState({required this.response});
}

class GetPaymentReportSuccessState extends GetPaymentReportStates {
  final PaymentReportModel model;

  GetPaymentReportSuccessState({required this.model});
}
