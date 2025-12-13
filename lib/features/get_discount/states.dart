part of 'bloc.dart';

class GetDiscountsStates {}

class GetDiscountsLoadingState extends GetDiscountsStates {}

class GetDiscountsFailedState extends GetDiscountsStates {
  final CustomResponse response;

  GetDiscountsFailedState({required this.response});
}

class GetDiscountsSuccessState extends GetDiscountsStates {
  final List<Discounts> list;

  GetDiscountsSuccessState({required this.list});
}
