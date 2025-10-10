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

class AddAddressBloc extends Bloc<AddAddressEvents, AddAddressStates> {
  final DioHelper _dio;


  AddAddressBloc(this._dio) : super(AddAddressStates()) {
    on<AddAddressEvent>(_sendData);
  }


  String? lat,lng;
 int?deliveryId;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();
 final addressNameController= TextEditingController();
 final streetController= TextEditingController();
 final buildingController= TextEditingController();
 final aptController= TextEditingController();
 final noteController= TextEditingController();





  void _sendData(AddAddressEvent event, Emitter<AddAddressStates> emit) async {
    emit(AddAddressLoadingState());
    final response = await _dio.send(
      "user/addresses",
      data: {
        "user_id": CacheHelper.id,
        'lat': lat,
        "lng": lng,
        "address": addressNameController.text,
        "delivery_id": deliveryId,

      },
    );
    if (response.isSuccess) {

      emit(AddAddressSuccessState(msg: response.msg));
    } else {
      emit(AddAddressFailedState(response: response));
    }
  }
}
