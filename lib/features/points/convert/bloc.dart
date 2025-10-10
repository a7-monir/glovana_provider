import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/logic/dio_helper.dart';
import '../../../../core/logic/helper_methods.dart';

part 'events.dart';
part 'states.dart';

class ConvertPointsBloc extends Bloc<ConvertPointsEvents, ConvertPointsStates> {
  final DioHelper _dio;

  ConvertPointsBloc(this._dio) : super(ConvertPointsStates()) {
    on<ConvertPointsEvent>(_sendData);
  }

  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();
  final points = TextEditingController();

  void _sendData(
    ConvertPointsEvent event,
    Emitter<ConvertPointsStates> emit,
  ) async {
    emit(ConvertPointsLoadingState());
    final response = await _dio.send(
      "user/points/convert",
      data: {"points_to_convert": int.parse(points.text)},
    );
    if (response.isSuccess) {
      emit(ConvertPointsSuccessState(msg: response.msg));
    } else {
      emit(ConvertPointsFailedState(response: response));
    }
  }
}
