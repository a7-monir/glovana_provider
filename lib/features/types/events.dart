part of'bloc.dart';

class GetTypesEvents {}

class GetTypesEvent extends GetTypesEvents {
  final bool withLoading;

  GetTypesEvent({this.withLoading=true});
}
