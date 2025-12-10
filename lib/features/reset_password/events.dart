part of 'bloc.dart';

class ResetPasswordEvents {}

class ResetPasswordEvent extends ResetPasswordEvents {
  final String phone;

  ResetPasswordEvent({required this.phone});
}
