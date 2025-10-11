import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glovana_provider/views/auth/login/view.dart';

import '../../../../core/logic/cache_helper.dart';
import '../../../../core/logic/dio_helper.dart';
import '../../../../core/logic/helper_methods.dart';
import '../../../views/home_nav/view.dart';

part 'events.dart';
part 'states.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvents, DeleteAccountStates> {
  final DioHelper _dioHelper;

  DeleteAccountBloc(this._dioHelper) : super(DeleteAccountStates()) {
    on<DeleteAccountEvent>(_sendData);
  }
  final reason=TextEditingController();

  Future<void> _sendData(
      DeleteAccountEvent event, Emitter<DeleteAccountStates> emit) async {
    emit(DeleteAccountLoadingState());
    final resp = await _dioHelper.send(
      "provider/delete_account",
      data: {
        'reason':reason.text
      }
    );
    if (resp.isSuccess) {
      await CacheHelper.logOut();
      emit(DeleteAccountSuccessState(msg: resp.msg));
      navigateTo(LoginView(), keepHistory: false);
    } else {
      emit(DeleteAccountFailedState(response: resp));
    }
  }
}
