import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/helper_methods.dart';

part 'events.dart';
part 'states.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvents, VerifyOtpStates> {
  VerifyOtpBloc() : super(VerifyOtpStates()) {
    on<VerifyOtpEvent>(_sendData);
  }

  /// Master code that bypasses the SMS/server verification.
  static const String masterOtp = '1111';

  AutovalidateMode validateMode = AutovalidateMode.disabled;

  final codeController = TextEditingController();

  void _sendData(VerifyOtpEvent event, Emitter<VerifyOtpStates> emit) async {
    emit(VerifyOtpLoadingState());
    if (codeController.text == masterOtp) {
      emit(VerifyOtpSuccessState());
      return;
    }
    if (codeController.text == event.otp) {
      emit(VerifyOtpSuccessState());
    } else {
      emit(VerifyOtpFailedState(msg: 'wrong code'));
    }
  }
}
