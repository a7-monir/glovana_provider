import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';

import '../../core/logic/otp_controller.dart';

part 'events.dart';

part 'states.dart';

class VerifyOtpBloc extends Bloc<VerifyOtpEvents, VerifyOtpStates> {


  VerifyOtpBloc() : super(VerifyOtpStates()) {
    on<VerifyOtpEvent>(_sendData);
  }

  AutovalidateMode validateMode = AutovalidateMode.disabled;

  final codeController=TextEditingController();

  void _sendData(VerifyOtpEvent event, Emitter<VerifyOtpStates> emit) async {

      emit(VerifyOtpLoadingState());
      if (codeController.text == event.otp) {
        emit(VerifyOtpSuccessState());

      } else {
        emit(VerifyOtpFailedState(msg: 'wrong code'));

      }

  }
}
