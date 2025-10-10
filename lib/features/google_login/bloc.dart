import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';
import '../../core/logic/cache_helper.dart';
import '../../core/logic/firebase_notifications.dart';
import '../login/bloc.dart';

part 'events.dart';
part 'states.dart';

class SocialLoginBloc extends Bloc<SocialLoginEvents, SocialLoginStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  SocialLoginBloc(this._dio) : super(SocialLoginStates()) {
    on<SocialLoginEvent>(_sendData);
  }

  User? model;
  String? token, accessToken, name, email, photoUrl;
  String? googleId, appleId;

  bool isGoogle = true;

  void _sendData(
    SocialLoginEvent event,
    Emitter<SocialLoginStates> emit,
  ) async {
    isGoogle = event.isGoogle;
    emit(SocialLoginLoadingState());
    final response = await _dio.send(
      event.isGoogle ? "provider/google-login" : 'provider/apple-login',
      data: {
        if (!event.isGoogle) "apple_id": appleId,
        if (event.isGoogle) "google_id": googleId,
        "access_token": accessToken,
        "name": name,
        "email": email,
        "photo": photoUrl,
        "fcm_token": await GlobalNotification.getFcmToken(),
      },
    );
    if (response.isSuccess) {
      model = UserData.fromJson(response.data).userModel.user;
      token = UserData.fromJson(response.data).userModel.token;
      CacheHelper.setToken(token!);
      CacheHelper.saveData(model!);
      emit(SocialLoginSuccessState(msg: response.msg));
    } else {
      emit(
        SocialLoginFailedState(
          msg: response.msg,
          statusCode: response.statusCode,
        ),
      );
    }
  }
}
