part of 'bloc.dart';

class GetWalletStates {}

class GetWalletLoadingState extends GetWalletStates {}

class GetWalletFailedState extends GetWalletStates {
  final CustomResponse response;

  GetWalletFailedState({required this.response});
}

class GetWalletSuccessState extends GetWalletStates {
  final WalletModel model;

  GetWalletSuccessState({required this.model});
}
