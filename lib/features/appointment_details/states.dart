part of 'bloc.dart';

class GetAppointmentDetailsStates {}

class GetAppointmentDetailsLoadingState extends GetAppointmentDetailsStates {}

class GetAppointmentDetailsFailedState extends GetAppointmentDetailsStates {
  final CustomResponse response;

  GetAppointmentDetailsFailedState({required this.response});
}

class GetAppointmentDetailsSuccessState extends GetAppointmentDetailsStates {
  final Appointment model;

  GetAppointmentDetailsSuccessState({required this.model});
}
