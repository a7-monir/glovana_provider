import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';

part 'events.dart';
part 'states.dart';

class DeleteGallaryBloc extends Bloc<DeleteGallaryEvents, DeleteGallaryStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  DeleteGallaryBloc(this._dio) : super(DeleteGallaryStates()) {
    on<DeleteGallaryEvent>(_sendData);
  }
  final name = TextEditingController();
  final description = TextEditingController();

  void _sendData(
    DeleteGallaryEvent event,
    Emitter<DeleteGallaryStates> emit,
  ) async {
    emit(DeleteGallaryLoadingState());
    final response = await _dio.deleteData(
      url: "provider/gallery",
      data: {
        "gallery_ids": [event.galleryId],
      },
    );
    if (response.isSuccess) {
      emit(DeleteGallarySuccessState(response: response));
    } else {
      emit(DeleteGallaryFailedState(response: response));
    }
  }
}
