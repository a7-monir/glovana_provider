part of 'bloc.dart';

class SendOtpEvents {}

class SendOtpEvent extends SendOtpEvents {
  final String phone;

  SendOtpEvent({required this.phone});
}
