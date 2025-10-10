part of 'bloc.dart';

class GetPointsStates {}

class GetPointsLoadingState extends GetPointsStates {}

class GetPointsFailedState extends GetPointsStates {
  final CustomResponse response;

  GetPointsFailedState({required this.response});
}

class GetPointsSuccessState extends GetPointsStates {
  final PointsModel model;

  GetPointsSuccessState({required this.model});
}
