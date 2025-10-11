part of 'bloc.dart';

class GetProviderProfileStates {}

class GetProviderProfileLoadingState extends GetProviderProfileStates {}

class GetProviderProfileFailedState extends GetProviderProfileStates {
  final CustomResponse response;

  GetProviderProfileFailedState({required this.response});
}

class GetProviderProfileSuccessState extends GetProviderProfileStates {
  final Provider model;

  GetProviderProfileSuccessState({required this.model});
}
