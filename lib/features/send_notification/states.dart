part of 'bloc.dart';

class SendNotificationsStates {}

class SendNotificationsLoadingState extends SendNotificationsStates {}

class SendNotificationsFailedState extends SendNotificationsStates {
  final CustomResponse response;

  SendNotificationsFailedState({required this.response}) {
    showMessage(response.msg);
  }
}

class SendNotificationsSuccessState extends SendNotificationsStates {
  final String msg;

  SendNotificationsSuccessState({required this.msg});
}

class UploadFilesFailedState extends SendNotificationsStates {
  final String msg;

  UploadFilesFailedState({required this.msg}) {
    showMessage(msg);
  }
}

class UploadFilesSuccessState extends SendNotificationsStates {
  final String msg;
  final UploadFileModel uploadFileModel;
  UploadFilesSuccessState({required this.msg, required this.uploadFileModel});
}
