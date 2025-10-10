part of 'bloc.dart';

class SocialLoginEvents {}

class SocialLoginEvent extends SocialLoginEvents {
  final bool isGoogle;

  SocialLoginEvent({required this.isGoogle});
}
