part of 'bloc.dart';

class DeleteGallaryStates {}

class DeleteGallaryLoadingState extends DeleteGallaryStates {
}
class DeleteGallarySuccessState extends DeleteGallaryStates {
  final CustomResponse response;

  DeleteGallarySuccessState({required this.response}){
    showMessage(response.msg,type: MessageType.success);
  }
}

class DeleteGallaryFailedState extends DeleteGallaryStates {
  final CustomResponse response;

  DeleteGallaryFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}


