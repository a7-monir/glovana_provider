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

class AddDiscountBloc extends Bloc<AddDiscountEvents, AddDiscountStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  AddDiscountBloc(this._dio) : super(AddDiscountStates()) {
    on<AddDiscountEvent>(_sendData);
  }
final name=TextEditingController();
final description=TextEditingController();

  void _sendData(AddDiscountEvent event, Emitter<AddDiscountStates> emit) async {
    emit(AddDiscountLoadingState());
    final response = await _dio.send(
      "provider/discounts",
      data: {
        "provider_type_id": event.providerId,
        "name": name.text,
        "description": description.text,
        "percentage": event.percentage,
        "start_date": event.startDate,
        "end_date":event.endDate,
        "is_active": true,
        "service_ids": event.serviceIds

      },
    );
    if (response.isSuccess) {

      emit(AddDiscountSuccessState(response: response));
    } else {
      emit(AddDiscountFailedState(response: response));
    }
  }
}
