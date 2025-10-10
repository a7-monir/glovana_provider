import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/logic/cache_helper.dart';
import '../../../../core/logic/dio_helper.dart';
import '../../../../core/logic/helper_methods.dart';
import '../../views/auth/login/view.dart';

part 'events.dart';
part 'states.dart';

class SignOutBloc extends Bloc<SignOutEvents, SignOutStates> {
  final DioHelper _dioHelper;

  SignOutBloc(this._dioHelper) : super(SignOutStates()) {
    on<SignOutEvent>(_sendData);
  }

  Future<void> _sendData(
    SignOutEvent event,
    Emitter<SignOutStates> emit,
  ) async {
    emit(SignOutLoadingState());

    try {
      // if (await _googleSignIn.()) {
      await GoogleSignIn().signOut();
      // }
    } catch (e) {
      log('Error signing out from Google: $e');
      emit(SignOutFailedState(msg: e.toString()));
    }
    await CacheHelper.logOut();
    emit(SignOutSuccessState());
    navigateTo(LoginView(), keepHistory: false);

    // final resp = await _dioHelper.send(
    //   "Authorization/Logout",
    //   method: APIMethods.delete,
    // );
    // if (resp.isSuccess) {
    //   await CacheHelper.logOut();
    //   emit(SignOutSuccessState(msg: resp.msg));
    // } else {
    //   emit(SignOutFailedState(response: resp));
    // }
  }
}
