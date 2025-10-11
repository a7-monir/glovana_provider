part of 'bloc.dart';

class ProviderUpdateStatusStates {}

class ProviderUpdateStatusLoadingState extends ProviderUpdateStatusStates {}

class ProviderUpdateStatusFailedState extends ProviderUpdateStatusStates {
  final CustomResponse response;

  ProviderUpdateStatusFailedState({required this.response,}) {
    showMessage(response.msg);
  }
}

class ProviderUpdateStatusSuccessState extends ProviderUpdateStatusStates {
  final int status;

  ProviderUpdateStatusSuccessState({required this.status});
}
