part of 'bloc.dart';

class GetRatingsStates {}

class GetRatingsLoadingState extends GetRatingsStates {}

class GetRatingsFailedState extends GetRatingsStates {
  final CustomResponse response;

  GetRatingsFailedState({required this.response});
}

class GetRatingsSuccessState extends GetRatingsStates {
  final List<RatingModel> list;

  GetRatingsSuccessState({required this.list});
}
