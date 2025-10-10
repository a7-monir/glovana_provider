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
import '../login/bloc.dart';
part 'events.dart';
part 'states.dart';

class SignupBloc extends Bloc<SignupEvents, SignupStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  SignupBloc(this._dio) : super(SignupStates()) {
    on<SignupEvent>(_sendData);
  }
  final firstNameController = TextEditingController(text: kDebugMode?"Ahmed":null);
  final lastNameController = TextEditingController(text: kDebugMode?"Monir":null);
  final phoneController = TextEditingController(text: kDebugMode?"0795970357":null);
  final passwordController = TextEditingController(text: kDebugMode?"123456789":null);
  final emailController = TextEditingController(text: kDebugMode?"ahmed@gmail.com":null);
  User? model;
  String? token;
  bool passwordValid=true;
  bool emailValid=true;
  bool phoneValid=true;
  bool firstNameValid=true;
  bool lastNameValid=true;

  void _sendData(
    SignupEvent event,
    Emitter<SignupStates> emit,
  ) async {

      emit(SignupLoadingState());
      final response = await _dio.send(
        "user/register",
        data: {
          "name":"${firstNameController.text} ${lastNameController.text}",
          "phone": phoneController.text,
          'password':passwordController.text,
          "email":emailController.text,
          "user_type":"provider",
         "fcm_token": await GlobalNotification.getFcmToken(),
        },

      );
      if (response.isSuccess) {
        model = UserData.fromJson(response.data).userModel.user;
        token = UserData.fromJson(response.data).userModel.token;
        CacheHelper.setToken(token!);
        CacheHelper.saveData(model!);
        emit(SignupSuccessState(msg: response.msg));
      } else {
        emit(SignupFailedState(msg: response.msg, statusCode: response.statusCode));
      }

  }

}
