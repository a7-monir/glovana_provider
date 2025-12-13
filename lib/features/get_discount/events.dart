part of'bloc.dart';

class GetDiscountsEvents {}

class GetDiscountsEvent extends GetDiscountsEvents {
  final int providerTypeId;

  GetDiscountsEvent({required this.providerTypeId});
}