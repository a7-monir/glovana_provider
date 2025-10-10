part of 'bloc.dart';

class GetDeliveryStates {}

class GetDeliveryLoadingState extends GetDeliveryStates {}

class GetDeliveryFailedState extends GetDeliveryStates {
  final CustomResponse response;

  GetDeliveryFailedState({required this.response});
}

class GetDeliverySuccessState extends GetDeliveryStates {
  final List<Delivery>list;

  GetDeliverySuccessState({required this.list});
}
