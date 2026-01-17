part of 'bloc.dart';

class GetSettingsStates {}

class GetSettingsLoadingState extends GetSettingsStates {}

class GetSettingsFailedState extends GetSettingsStates {
  final CustomResponse response;

  GetSettingsFailedState({required this.response});
}

class GetSettingsSuccessState extends GetSettingsStates {
  final SettingsModel model;

  GetSettingsSuccessState({required this.model});
}
