import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';
import '../../core/logic/cache_helper.dart';
import '../../core/logic/firebase_notifications.dart';
import '../../generated/locale_keys.g.dart';

part 'events.dart';


part 'states.dart';

class UpdateStatusBloc extends Bloc<UpdateStatusEvents, UpdateStatusStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  UpdateStatusBloc(this._dio) : super(UpdateStatusStates()) {
    on<UpdateStatusEvent>(_sendData);
  }
final reason=TextEditingController();

  void _sendData(UpdateStatusEvent event, Emitter<UpdateStatusStates> emit) async {
    emit(UpdateStatusLoadingState());
    final response = await _dio.send(
      "provider/appointments/${event.id}/status",
      data: {
        "status": event.newStatus.toString(),
        'reason':reason.text

      },
    );
    if (response.isSuccess) {

      emit(UpdateStatusSuccessState());
    } else {
      emit(UpdateStatusFailedState(response: response));
    }
  }
}
