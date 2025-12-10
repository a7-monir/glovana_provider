import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';

import '../../core/logic/otp_controller.dart';

part 'events.dart';

part 'states.dart';

class SendOtpBloc extends Bloc<SendOtpEvents, SendOtpStates> {


  SendOtpBloc() : super(SendOtpStates()) {
    on<SendOtpEvent>(_sendData);
  }

  AutovalidateMode validateMode = AutovalidateMode.disabled;



  String generateOtp() {
    return (1000 + Random().nextInt(9000)).toString();
  }


  void _sendData(SendOtpEvent event, Emitter<SendOtpStates> emit) async {
    try {
      emit(SendOtpLoadingState());
      final smsService = JorMallSmsService();

      final token = await smsService.generateToken();
      if (token != null) {
        final otp = generateOtp();
        final success = await smsService.sendOtpSms(
          token: token,
          phoneNumber: "9620${event.phone}",
          otpCode: otp,
        );

        if (success) {
          print('OTP sent to ${event.phone}');
          emit(SendOtpSuccessState(otp: otp));

        } else {
          emit(SendOtpFailedState(msg: 'OTP Failed sent to ${event.phone}'));

          print('Failed to send OTP');
        }
      } else {
        emit(SendOtpFailedState(msg: 'OTP Failed sent to ${event.phone}'));
        print('Could not generate token');
      }
    } catch (e) {
      emit(SendOtpFailedState(msg: 'OTP Failed sent to $e'));

    }



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
