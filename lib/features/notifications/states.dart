part of 'bloc.dart';

class GetNotificationsStates {}

class GetNotificationsLoadingState extends GetNotificationsStates {}

class GetNotificationsFailedState extends GetNotificationsStates {
  final CustomResponse response;


  GetNotificationsFailedState({required this.response});
}

class GetNotificationsSuccessState extends GetNotificationsStates {
  final List<NotificationData> list;

  GetNotificationsSuccessState({required this.list});
}