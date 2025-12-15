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

class DeleteGallaryBloc extends Bloc<DeleteGallaryEvents, DeleteGallaryStates> {
  final DioHelper _dio;
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  final formKey = GlobalKey<FormState>();

  DeleteGallaryBloc(this._dio) : super(DeleteGallaryStates()) {
    on<DeleteGallaryEvent>(_sendData);
  }
final name=TextEditingController();
final description=TextEditingController();

  void _sendData(DeleteGallaryEvent event, Emitter<DeleteGallaryStates> emit) async {
    emit(DeleteGallaryLoadingState());
    final response = await _dio.send(
      "provider/gallery",
      method: APIMethods.delete,
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
