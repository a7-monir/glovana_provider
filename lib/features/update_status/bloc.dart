import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';

part 'events.dart';
part 'states.dart';

class UpdateStatusBloc extends Bloc<UpdateStatusEvents, UpdateStatusStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  UpdateStatusBloc(this._dio) : super(UpdateStatusStates()) {
    on<UpdateStatusEvent>(_sendData);
  }
  final reason = TextEditingController();

  void resetCancelReasonForm() {
    validateMode = AutovalidateMode.disabled;
    formKey.currentState?.reset();
    reason.clear();
  }

  void _sendData(
    UpdateStatusEvent event,
    Emitter<UpdateStatusStates> emit,
  ) async {
    emit(UpdateStatusLoadingState());
    final trimmedReason = reason.text.trim();
    final response = await _dio.send(
      "provider/appointments/${event.id}/status",
      data: {
        "status": event.newStatus.toString(),
        if (event.newStatus == 5) 'reason_of_cancel': trimmedReason,
      },
    );
    if (response.isSuccess) {
      emit(UpdateStatusSuccessState());
    } else {
      emit(UpdateStatusFailedState(response: response));
    }
  }
}
