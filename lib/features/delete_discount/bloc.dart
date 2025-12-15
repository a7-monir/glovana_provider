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

class DeleteDiscountBloc extends Bloc<DeleteDiscountEvents, DeleteDiscountStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  DeleteDiscountBloc(this._dio) : super(DeleteDiscountStates()) {
    on<DeleteDiscountEvent>(_sendData);
  }
final name=TextEditingController();
final description=TextEditingController();

  void _sendData(DeleteDiscountEvent event, Emitter<DeleteDiscountStates> emit) async {
    emit(DeleteDiscountLoadingState());
    final response = await _dio.deleteData(
      url: "provider/discounts/${event.id}",

    );
    if (response.isSuccess) {

      emit(DeleteDiscountSuccessState(response: response));
    } else {
      emit(DeleteDiscountFailedState(response: response));
    }
  }
}
