part of 'bloc.dart';

class GetTypesStates {}

class GetTypesLoadingState extends GetTypesStates {}

class GetTypesFailedState extends GetTypesStates {
  final CustomResponse response;


  GetTypesFailedState({required this.response});
}

class GetTypesSuccessState extends GetTypesStates {
  final List<TypeModel> list;

  GetTypesSuccessState({required this.list});
}