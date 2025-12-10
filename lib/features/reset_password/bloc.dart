import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';
import '../../core/logic/cache_helper.dart';
import '../../core/logic/firebase_notifications.dart';

part 'events.dart';
part 'states.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvents, ResetPasswordStates> {
  final DioHelper _dio;

  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  ResetPasswordBloc(this._dio) : super(ResetPasswordStates()) {
    on<ResetPasswordEvent>(_sendData);
  }

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  Future<void> _sendData(ResetPasswordEvent event, Emitter<ResetPasswordStates> emit) async {
    emit(ResetPasswordLoadingState());
    try {
      final response = await _dio.send(
        'provider/update-password',
        data: {
          'phone': event.phone,
          'password': passwordController.text.trim(),
        },
      );

      if (!response.isSuccess) {
        emit(ResetPasswordFailedState(msg: response.msg, statusCode: response.statusCode));
        return;
      }

      emit(ResetPasswordSuccessState(msg: response.msg));
    } catch (e) {
      emit(ResetPasswordFailedState(msg: e.toString(), statusCode: 0));
    }
  }
}
