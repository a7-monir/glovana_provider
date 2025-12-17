import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/logic/dio_helper.dart';
import '../../../core/logic/helper_methods.dart';

part 'events.dart';
part 'states.dart';

class SendNotificationsBloc
    extends Bloc<SendNotificationsEvents, SendNotificationsStates> {
  final DioHelper _dio;

  SendNotificationsBloc(this._dio) : super(SendNotificationsStates()) {
    on<SendNotificationsEvent>(_sendData);
    on<UploadFileEvent>(_uploadFiles);
  }

  void _sendData(
    SendNotificationsEvent event,
    Emitter<SendNotificationsStates> emit,
  ) async {
    emit(SendNotificationsLoadingState());
    final response = await _dio.send(
      "provider/notifications",
      data: {'user_id': event.userId, 'title': event.title, 'body': event.body},
    );
    if (response.isSuccess) {
      emit(SendNotificationsSuccessState(msg: response.msg));
    } else {
      emit(SendNotificationsFailedState(response: response));
    }
  }

  void _uploadFiles(
    UploadFileEvent event,
    Emitter<SendNotificationsStates> emit,
  ) async {
    try {
      FormData formData = FormData.fromMap({});

      if (event.image != null) {
        formData.files.add(
          MapEntry('photo', await MultipartFile.fromFile(event.image!.path)),
        );
      }
      if (event.voice != null) {
        formData.files.add(
          MapEntry('voice', await MultipartFile.fromFile(event.voice!.path)),
        );
      }
      final response = await _dio.postData(
        url: 'provider/uploadPhotoVoice',
        data: formData,
      );

      if ((response.statusCode == 200 || response.statusCode == 201)) {
        final model = UploadFileModel.fromJson(response.data);
        emit(
          UploadFilesSuccessState(
            msg: response.data["message"],
            uploadFileModel: model,
          ),
        );
      } else {
        emit(
          UploadFilesFailedState(
            msg: response.data['message'] ?? "something_went_wrong".tr(),
          ),
        );
      }
    } catch (e) {
      emit(UploadFilesFailedState(msg: e.toString()));
    }
  }

  // Future<Either<ErrorGlobalModel, UploadFileModel>> uploadFiles({
  //   File? image,
  //   File? voice,
  // }) async {
  //   try {
  //     FormData formData = FormData.fromMap({});
  //
  //     if (image != null) {
  //       formData.files.add(
  //         MapEntry('photo', await MultipartFile.fromFile(image.path)),
  //       );
  //     }
  //     if (voice != null) {
  //       formData.files.add(
  //         MapEntry('voice', await MultipartFile.fromFile(voice.path)),
  //       );
  //     }
  //     final response = await _dio.postData(
  //       url: 'user/uploadPhotoVoice',
  //       data: formData,
  //     );
  //
  //     if ((response.statusCode == 200 || response.statusCode == 201)) {
  //       return Right(UploadFileModel.fromJson(response.data));
  //     } else {
  //       return Left(
  //         ErrorGlobalModel(
  //           message: response.data['message'] ?? "something_went_wrong".tr(),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     return Left(ErrorGlobalModel(message: e.toString()));
  //   }
  // }
}

class UploadFileModel {
  String? message;
  Data2? data;

  UploadFileModel({this.message, this.data});

  factory UploadFileModel.fromJson(Map<String, dynamic> json) =>
      UploadFileModel(
        message: json["message"],
        data: json["data"] == null ? null : Data2.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data2 {
  int? userId;
  String? photo;
  String? voice;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data2({
    this.userId,
    this.photo,
    this.voice,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data2.fromJson(Map<String, dynamic> json) => Data2(
    userId: json["user_id"],
    photo: json["photo"],
    voice: json["voice"],
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "photo": photo,
    "voice": voice,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
