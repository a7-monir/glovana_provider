part of 'bloc.dart';

class GetAppointmentDetailsEvents {}

class GetAppointmentDetailsEvent extends GetAppointmentDetailsEvents {
  final int id;

  GetAppointmentDetailsEvent({required this.id});


}
