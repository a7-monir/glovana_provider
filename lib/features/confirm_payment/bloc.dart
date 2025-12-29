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

class ConfirmPaymentBloc extends Bloc<ConfirmPaymentEvents, ConfirmPaymentStates> {
  final DioHelper _dio;


  ConfirmPaymentBloc(this._dio) : super(ConfirmPaymentStates()) {
    on<ConfirmPaymentEvent>(_sendData);
  }


  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();


  void _sendData(ConfirmPaymentEvent event, Emitter<ConfirmPaymentStates> emit) async {
    emit(ConfirmPaymentLoadingState());
    final response = await _dio.send(
      "provider/appointments/${event.id}/confirm-payment",
      data: {
        "payment_confirmed":true


      },
    );
    if (response.isSuccess) {

      emit(ConfirmPaymentSuccessState(msg: response.msg));
    } else {
      emit(ConfirmPaymentFailedState(response: response));
    }
  }
}
