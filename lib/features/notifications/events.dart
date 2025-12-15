part of'bloc.dart';

class GetNotificationsEvents {}

class GetNotificationsEvent extends GetNotificationsEvents {
  final bool withLoading;

  GetNotificationsEvent({this.withLoading=true});
}
