import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';
import '../../core/logic/cache_helper.dart';

import '../../core/logic/firebase_notifications.dart';
import '../login/bloc.dart';

part 'events.dart';

part 'states.dart';

class EditProfileBloc extends Bloc<EditProfileEvents, EditProfileStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  EditProfileBloc(this._dio) : super(EditProfileStates()) {
    on<EditProfileEvent>(_sendData);
  }

  String first = CacheHelper.name.split(' ').first;

  final phoneController = TextEditingController(text: CacheHelper.phone);
  final emailController = TextEditingController(text: CacheHelper.email);
  final firstNameController = TextEditingController(text: CacheHelper.name.split(' ').first);
  final lastNameController = TextEditingController(
    text: CacheHelper.name.split(' ').length > 1 ? CacheHelper.name.split(' ').last : null,
  );

  User? model;
  String? token;
  String? photo;
  bool emailValid = true;
  bool firstNameValid = true;
  bool lastNameValid = true;
  bool phoneValid = true;

  void _sendData(EditProfileEvent event, Emitter<EditProfileStates> emit) async {
    emit(EditProfileLoadingState());
    final response = await _dio.send(
      "user/update_profile",
      data: {
        "name": "${firstNameController.text} ${lastNameController.text}",
        'phone': phoneController.text,
        'email': emailController.text,
        if (photo != null) 'photo':  await MultipartFile.fromFile(photo!, filename: photo!.split('/').last),
        "user_type": "provider",
        "fcm_token": await GlobalNotification.getFcmToken(),
      },
      headers: {
        'Content-Type':  "multipart/form-data"
      }

    );
    if (response.isSuccess) {
      model = User.fromJson(response.data['data']);
      token = CacheHelper.token;
      CacheHelper.saveData(model!);
      emit(EditProfileSuccessState(msg: response.msg));
    } else {
      emit(EditProfileFailedState(msg: response.msg, statusCode: response.statusCode));
    }
  }
}
