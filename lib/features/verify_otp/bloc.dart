import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/helper_methods.dart';

part 'events.dart';
part 'states.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvents, VerifyOtpStates> {
  VerifyOtpBloc() : super(VerifyOtpStates()) {
    on<VerifyOtpEvent>(_sendData);
  }

  // OTP is disabled for all builds.
  // static const String masterOtp = '1111';

  AutovalidateMode validateMode = AutovalidateMode.disabled;

  final codeController = TextEditingController();

  void _sendData(VerifyOtpEvent event, Emitter<VerifyOtpStates> emit) {
    emit(VerifyOtpFailedState(msg: 'OTP is disabled'));

    /* Original OTP verification implementation is intentionally disabled.
    emit(VerifyOtpLoadingState());
    if (codeController.text == masterOtp || codeController.text == event.otp) {
      emit(VerifyOtpSuccessState());
    } else {
      emit(VerifyOtpFailedState(msg: 'wrong code'));
    }
    */
  }
}
