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

part 'model.dart';

part 'states.dart';

class LoginBloc extends Bloc<LoginEvents, LoginStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  LoginBloc(this._dio) : super(LoginStates()) {
    on<LoginEvent>(_sendData);
  }

  final phoneController = TextEditingController(text: kDebugMode ? "0799966613" : null);
  final passwordController = TextEditingController(text: kDebugMode ? "123456789" : null);
  User? model;
  String? token;
  bool passwordValid = true;
  bool phoneValid = true;

  void _sendData(LoginEvent event, Emitter<LoginStates> emit) async {
    emit(LoginLoadingState());
    final response = await _dio.send(
      "user/login",
      data: {
        "phone": phoneController.text,
        'password': passwordController.text,
        "user_type": "provider",

        "fcm_token": await GlobalNotification.getFcmToken(),
      },
    );
    if (response.isSuccess) {
      model = UserData.fromJson(response.data).userModel.user;
      token = UserData.fromJson(response.data).userModel.token;
      CacheHelper.setToken(token!);
      CacheHelper.saveData(model!);
      emit(LoginSuccessState(msg: response.msg));
    } else {
      emit(LoginFailedState(msg: response.msg, statusCode: response.statusCode));
    }
  }
}
