part of 'bloc.dart';

class DeleteDiscountEvents {}

class DeleteDiscountEvent extends DeleteDiscountEvents {
  final int id;


  DeleteDiscountEvent({required this.id});

}
