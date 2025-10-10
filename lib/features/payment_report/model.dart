part of 'bloc.dart';

class PaymentReportData {
  late final bool status;
  late final String message;
  late final PaymentReportModel data;

  PaymentReportData.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? false;
    message = json['message'] ?? '';
    data = PaymentReportModel.fromJson(json['data'] ?? {});
  }
}

class PaymentReportModel {
  late final int totalAppointments;
  late final double totalAmount;
  late final double totalCommission;
  late final double totalProviderEarnings;
  late final List<PaymentAppointment> appointments;

  PaymentReportModel.fromJson(Map<String, dynamic> json) {
    totalAppointments = json['total_appointments'] ?? 0;
    totalAmount = (json['total_amount'] ?? 0).toDouble();
    totalCommission = (json['total_commission'] ?? 0).toDouble();
    totalProviderEarnings = (json['total_provider_earnings'] ?? 0).toDouble();
    appointments = List.from(
      json['appointments'] ?? [],
    ).map((e) => PaymentAppointment.fromJson(e)).toList();
  }
}

class PaymentAppointment {
  late final int id;
  late final int number;
  late final String date;
  late final String status;
  late final String paymentType;
  late final String paymentStatus;
  late final double total;
  late final double commission;
  late final double providerEarnings;

  PaymentAppointment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    number = json['number'] ?? 0;
    date = json['date'] ?? '';
    status = json['status'] ?? '';
    paymentType = json['payment_type'] ?? '';
    paymentStatus = json['payment_status'] ?? '';
    total = (json['total'] ?? 0).toDouble();
    commission = (json['commission'] ?? 0).toDouble();
    providerEarnings = (json['provider_earnings'] ?? 0).toDouble();
  }
}
