part of 'bloc.dart';

class EditProfileStates {}

class EditProfileLoadingState extends EditProfileStates {}

class EditProfileFailedState extends EditProfileStates {
  final String msg;
  final int? statusCode;

  EditProfileFailedState({required this.msg, this.statusCode}) {
    showMessage(msg);
  }
}

class EditProfileSuccessState extends EditProfileStates {
  final String msg;
  final User model;

  EditProfileSuccessState({required this.msg, required this.model});

}
