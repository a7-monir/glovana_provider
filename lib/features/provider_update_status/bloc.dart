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


part 'states.dart';

class ProviderUpdateStatusBloc extends Bloc<ProviderUpdateStatusEvents, ProviderUpdateStatusStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  ProviderUpdateStatusBloc(this._dio) : super(ProviderUpdateStatusStates()) {
    on<ProviderUpdateStatusEvent>(_sendData);
  }


  void _sendData(ProviderUpdateStatusEvent event, Emitter<ProviderUpdateStatusStates> emit) async {
    emit(ProviderUpdateStatusLoadingState());
    final response = await _dio.send(
      "provider/updateStatus/${CacheHelper.id}",

    );
    if (response.isSuccess) {

      emit(ProviderUpdateStatusSuccessState(status: response.data['data']['status']));
    } else {
      emit(ProviderUpdateStatusFailedState(response: response));
    }
  }
}
