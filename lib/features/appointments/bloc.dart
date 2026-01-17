import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/cache_helper.dart';
import '../../../core/logic/dio_helper.dart';

part 'events.dart';

part 'model.dart';

part 'states.dart';

enum AppointmentStatus {
  pending,
  confirmed,
  onTheWay,
  completed,
  canceled,
  arrivedUser,
  startWork,
}


class GetAppointmentsBloc
    extends Bloc<GetAppointmentsEvents, GetAppointmentsStates> {
  final DioHelper _dio;

  GetAppointmentsBloc(this._dio) : super(GetAppointmentsStates()) {
    on<GetAppointmentsEvent>(_getData);
    on<GetAllAppointmentsEvent>(_getAllData);
  }

  String? startDate, endDate;

  AppointmentStatus? status;
  String pendingLength='0';
  String acceptLength='0';
  String userArriveLength='0';
  String startWorkLength='0';
  String inWayLength='0';

  int? getStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return 1; // Assuming 1 is pending
      case AppointmentStatus.confirmed:
        return 2;
      case AppointmentStatus.onTheWay:
        return 3;
      case AppointmentStatus.completed:
        return 4;
      case AppointmentStatus.canceled:
        return 5;
      case AppointmentStatus.startWork:
        return 6;
      case AppointmentStatus.arrivedUser:
        return 7;
    }
  }

  String getAppointmentsCountByStatus(
    AppointmentStatus status,
    List<Appointment> list,
  ) {
    final statusValue = getStatus(status);

    if (statusValue == null) return '';

    final count = list
        .where((appointment) => appointment.appointmentStatus == statusValue)
        .length;

    return count.toString();
  }

  // switch (status) {
  // case AppointmentFilterStatus.pending:
  // return appointment.appointmentStatus == 1; // Assuming 1 is pending
  // case AppointmentFilterStatus.confirmed:
  // return appointment.appointmentStatus == 2;
  // case AppointmentFilterStatus.onTheWay:
  // return appointment.appointmentStatus == 3;
  // case AppointmentFilterStatus.completed:
  // return appointment.appointmentStatus == 4;
  // case AppointmentFilterStatus.canceled:
  // return appointment.appointmentStatus == 5; // Assuming 5 is canceled
  // default:
  // return true;
  // }
  List<Appointment> allList = [];

  void _getData(
    GetAppointmentsEvent event,
    Emitter<GetAppointmentsStates> emit,
  ) async {
    emit(GetAppointmentsLoadingState());
    final response = await _dio.get(
      "provider/appointments",
      params: {
        'status': status == null ? null : getStatus(status!),
        'date_from': startDate,
        "date_to": endDate,
      },
    );
    if (response.isSuccess) {
      final list = AppointmentData.fromJson(
        response.data,
      ).data.appointments.list;
      emit(GetAppointmentsSuccessState(list: list));
    } else {
      emit(GetAppointmentsFailedState(response: response));
    }
  }

  void _getAllData(
    GetAllAppointmentsEvent event,
    Emitter<GetAppointmentsStates> emit,
  ) async {
    emit(GetAllAppointmentsLoadingState());
    final response = await _dio.get(
      "provider/appointments",
      params: {'date_from': startDate, "date_to": endDate},
    );
    if (response.isSuccess) {
      allList = AppointmentData.fromJson(response.data).data.appointments.list;
      print("{{{{{{{{{{{object}}}}}}}}}}}");
      print("${allList.length}");
      pendingLength= getAppointmentsCountByStatus(AppointmentStatus.pending, allList);
      acceptLength= getAppointmentsCountByStatus(AppointmentStatus.confirmed, allList);
      userArriveLength= getAppointmentsCountByStatus(AppointmentStatus.arrivedUser, allList);
      startWorkLength= getAppointmentsCountByStatus(AppointmentStatus.startWork, allList);
      inWayLength= getAppointmentsCountByStatus(AppointmentStatus.onTheWay, allList);
      print("|||||$startWorkLength++++");
      print("{{{{{{{{{{{object}}}}}}}}}}}");
      emit(GetAllAppointmentsSuccessState());
    } else {
      emit(GetAllAppointmentsFailedState(response: response));
    }
  }
}
