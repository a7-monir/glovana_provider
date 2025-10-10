part of 'bloc.dart';

class UpdateStatusEvents {}

class UpdateStatusEvent extends UpdateStatusEvents {
  final int id,newStatus;

  UpdateStatusEvent({required this.id, required this.newStatus});
}
