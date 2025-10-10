import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glovana_provider/features/appointments/bloc.dart';

import '../../../core/logic/dio_helper.dart';

part 'events.dart';
part 'states.dart';

class GetAppointmentDetailsBloc extends Bloc<GetAppointmentDetailsEvents, GetAppointmentDetailsStates> {
  final DioHelper _dio;

  GetAppointmentDetailsBloc(this._dio) : super(GetAppointmentDetailsStates()) {
    on<GetAppointmentDetailsEvent>(_getData);
  }

  void _getData(
    GetAppointmentDetailsEvent event,
    Emitter<GetAppointmentDetailsStates> emit,
  ) async {
    emit(GetAppointmentDetailsLoadingState());
    final response = await _dio.get("provider/appointments/${event.id}",

    );
    if (response.isSuccess) {
      final model = Appointment.fromJson(response.data['data']['appointment']);
      emit(GetAppointmentDetailsSuccessState(model: model));
    } else {
      emit(GetAppointmentDetailsFailedState(response: response));
    }
  }
}
