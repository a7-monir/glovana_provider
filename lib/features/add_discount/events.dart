part of 'bloc.dart';

class AddDiscountEvents {}

class AddDiscountEvent extends AddDiscountEvents {
  final int providerId;
  final double percentage;
  final String startDate,endDate;
  final List<int> serviceIds;

  AddDiscountEvent({required this.providerId, required this.percentage, required this.startDate, required this.endDate, required this.serviceIds});

}
