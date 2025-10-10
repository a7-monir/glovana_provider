part of 'bloc.dart';

class GetAddressStates {}

class GetAddressLoadingState extends GetAddressStates {}

class GetAddressFailedState extends GetAddressStates {
  final CustomResponse response;

  GetAddressFailedState({required this.response});
}

class GetAddressSuccessState extends GetAddressStates {
  final List<AddressModel> list;

  GetAddressSuccessState({required this.list});
}
