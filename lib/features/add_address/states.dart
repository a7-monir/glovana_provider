part of 'bloc.dart';

class AddAddressStates {}

class AddAddressLoadingState extends AddAddressStates {}

class AddAddressFailedState extends AddAddressStates {
  final CustomResponse response;

  AddAddressFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}

class AddAddressSuccessState extends AddAddressStates {
  final String msg;

  AddAddressSuccessState({required this.msg});
}
