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

class CheckPhoneBloc extends Bloc<CheckPhoneEvents, CheckPhoneStates> {
  final DioHelper _dio;

  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  CheckPhoneBloc(this._dio) : super(CheckPhoneStates()) {
    on<CheckPhoneEvent>(_sendData);
  }

  final phoneController = TextEditingController(text: kDebugMode ? '799008912' : null);
  

  Future<void> _sendData(CheckPhoneEvent event, Emitter<CheckPhoneStates> emit) async {
    emit(CheckPhoneLoadingState());
    try {
      final response = await _dio.send(
        'provider/check-phone',
        data: {
          'phone': phoneController.text.trim(),
        },
      );

      if (!response.isSuccess) {
        emit(CheckPhoneFailedState(msg: response.msg, statusCode: response.statusCode));
        return;
      }

      emit(CheckPhoneSuccessState());
    } catch (e) {
      emit(CheckPhoneFailedState(msg: e.toString(), statusCode: 0));
    }
  }
}
