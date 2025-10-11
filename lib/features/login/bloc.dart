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
part 'model.dart';
part 'states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final DioHelper _dio;

  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  LoginBloc(this._dio) : super(LoginStates()) {
    on<LoginEvent>(_sendData);
  }

  final phoneController = TextEditingController(text: kDebugMode ? '0799966613' : null);
  final passwordController = TextEditingController(text: kDebugMode ? '123456789' : null);

  User? model;
  String? token;

  bool passwordValid = true;
  bool phoneValid = true;

  Future<void> _sendData(LoginEvent event, Emitter<LoginStates> emit) async {
    emit(LoginLoadingState());
    try {
      final fcm = await GlobalNotification.getFcmToken();

      final response = await _dio.send(
        'user/login',
        data: {
          'phone': phoneController.text.trim(),
          'password': passwordController.text,
          'user_type': 'provider',
          'fcm_token': fcm,
        },
      );

      if (!response.isSuccess) {
        emit(LoginFailedState(msg: response.msg, statusCode: response.statusCode));
        return;
      }

      final userData = UserData.fromJson(response.data);
      final userModel = userData.userModel;

      model = userModel.user;
      token = userModel.token;

      await CacheHelper.setToken(token ?? '');
      await CacheHelper.saveData(model!);

      phoneController.clear();
      passwordController.clear();

      emit(LoginSuccessState(msg: response.msg));
    } catch (e) {
      emit(LoginFailedState(msg: e.toString(), statusCode: 0));
    }
  }
}
