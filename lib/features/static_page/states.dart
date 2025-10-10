part of 'bloc.dart';

class GetStaticPageStates {}

class GetStaticPageLoadingState extends GetStaticPageStates {}

class GetStaticPageFailedState extends GetStaticPageStates {
  final CustomResponse response;

  GetStaticPageFailedState({required this.response});
}

class GetStaticPageSuccessState extends GetStaticPageStates {
  final PageData model;

  GetStaticPageSuccessState({required this.model});
}
