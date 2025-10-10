part of 'bloc.dart';

class GetServicesStates {}

class GetServicesLoadingState extends GetServicesStates {}

class GetServicesFailedState extends GetServicesStates {
  final CustomResponse response;

  GetServicesFailedState({required this.response});
}

class GetServicesSuccessState extends GetServicesStates {
  final List<Service2>list;

  GetServicesSuccessState({required this.list});
}
