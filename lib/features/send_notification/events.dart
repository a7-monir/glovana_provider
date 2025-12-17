part of 'bloc.dart';

class SendNotificationsEvents {}

class SendNotificationsEvent extends SendNotificationsEvents {
  final String userId, title, body;

  SendNotificationsEvent({
    required this.userId,
    required this.title,
    required this.body,
  });
}

class UploadFileEvent extends SendNotificationsEvents {
  File? image;
  File? voice;

  UploadFileEvent({this.image, this.voice});
}
