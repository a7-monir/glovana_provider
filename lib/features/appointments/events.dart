part of'bloc.dart';

class GetAppointmentsEvents {}

class GetAppointmentsEvent extends GetAppointmentsEvents {
  final bool withLoading;

  GetAppointmentsEvent({ this.withLoading=true});
}
class GetAllAppointmentsEvent extends GetAppointmentsEvents {
  final bool withLoading;

  GetAllAppointmentsEvent({ this.withLoading=true});
}