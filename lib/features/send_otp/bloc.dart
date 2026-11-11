// OTP is disabled for all builds.
// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/logic/app_logger.dart';
// import '../../core/logic/otp_controller.dart';

part 'events.dart';
part 'states.dart';

class SendOtpBloc extends Bloc<SendOtpEvents, SendOtpStates> {
  SendOtpBloc() : super(SendOtpStates()) {
    on<SendOtpEvent>(_sendData);
  }

  AutovalidateMode validateMode = AutovalidateMode.disabled;

  // String generateOtp() {
  //   return (1000 + Random().nextInt(9000)).toString();
  // }

  void _sendData(SendOtpEvent event, Emitter<SendOtpStates> emit) {
    AppLogger.warning(
      'OTP send request ignored because OTP is disabled',
      tag: 'AUTH',
      data: {'phone': event.phone},
    );
    emit(SendOtpFailedState(msg: 'OTP is disabled'));

    /* Original OTP sending implementation is intentionally disabled.
    try {
      emit(SendOtpLoadingState());
      final smsService = JorMallSmsService();
      final token = await smsService.generateToken();
      if (token != null) {
        final otp = generateOtp();
        final success = await smsService.sendOtpSms(
          token: token,
          phoneNumber: "962${event.phone}",
          otpCode: otp,
        );
        if (success) {
          emit(SendOtpSuccessState(otp: otp));
        } else {
          emit(SendOtpFailedState(msg: 'OTP Failed sent to ${event.phone}'));
        }
      } else {
        emit(SendOtpFailedState(msg: 'OTP Failed sent to ${event.phone}'));
      }
    } catch (e) {
      emit(SendOtpFailedState(msg: 'OTP Failed sent to $e'));
    }
    */

    // final response = await _dio.send(
    //   "user/addresses",
    //   data: {
    //     "user_id": CacheHelper.id,
    //     'lat': lat,
    //     "lng": lng,
    //     "address": addressNameController.text,
    //     "delivery_id": deliveryId,
    //
    //   },
    // );
    // if (response.isSuccess) {
    //
    //   emit(SendOtpSuccessState(msg: response.msg));
    // } else {
    //   emit(SendOtpFailedState(response: response));
    // }
  }
}
