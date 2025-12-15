part of 'bloc.dart';

class DeleteDiscountStates {}

class DeleteDiscountLoadingState extends DeleteDiscountStates {
}
class DeleteDiscountSuccessState extends DeleteDiscountStates {
  final CustomResponse response;

  DeleteDiscountSuccessState({required this.response}){
    showMessage(response.msg,type: MessageType.success);
  }
}

class DeleteDiscountFailedState extends DeleteDiscountStates {
  final CustomResponse response;

  DeleteDiscountFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}


