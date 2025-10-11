part of 'bloc.dart';

class DeleteAccountStates {}

class DeleteAccountLoadingState extends DeleteAccountStates {}

class DeleteAccountSuccessState extends DeleteAccountStates {
  final String msg;

  DeleteAccountSuccessState({required this.msg}) {
    showMessage(msg, type: MessageType.success);
  }
}

class DeleteAccountFailedState extends DeleteAccountStates {
  final CustomResponse response;

  DeleteAccountFailedState({required this.response}) {
    pop();
    showMessage(response.msg);
  }
}
