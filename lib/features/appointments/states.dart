part of 'bloc.dart';

class GetAppointmentsStates {}

class GetAppointmentsLoadingState extends GetAppointmentsStates {}

class GetAppointmentsFailedState extends GetAppointmentsStates {
  final CustomResponse response;

  GetAppointmentsFailedState({required this.response});
}

class GetAppointmentsSuccessState extends GetAppointmentsStates {
  final List<Appointment> list;

  GetAppointmentsSuccessState({required this.list});
}
