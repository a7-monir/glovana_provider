part of 'bloc.dart';

class ProviderUpdateStatusEvents {}

class ProviderUpdateStatusEvent extends ProviderUpdateStatusEvents {
  final int typeId;

  ProviderUpdateStatusEvent({required this.typeId});
}
