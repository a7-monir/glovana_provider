part of 'bloc.dart';

class AddDiscountStates {}

class AddDiscountLoadingState extends AddDiscountStates {
}
class AddDiscountSuccessState extends AddDiscountStates {
  final CustomResponse response;

  AddDiscountSuccessState({required this.response}){
    showMessage(response.msg,type: MessageType.success);
  }
}

class AddDiscountFailedState extends AddDiscountStates {
  final CustomResponse response;

  AddDiscountFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}


