part of 'bloc.dart';

class AppointmentData {
  late final bool status;
  late final String message;
  late final Appointments data;

  AppointmentData.fromJson(Map<String, dynamic> json) {
    status = json["status"] ?? false;
    message = json["message"] ?? '';
    data = Appointments.fromJson(json["data"] ?? {});
  }
}

class Appointments {
  late final AppointmentsModel appointments;

  Appointments.fromJson(Map<String, dynamic> json) {
    appointments = AppointmentsModel.fromJson(json["appointments"] ?? {});
  }
}

class AppointmentsModel {

  late final List<Appointment> list;

  AppointmentsModel.fromJson(Map<String, dynamic> json) {

    list = List.from(json["data"]??[])
        .map((x) => Appointment.fromJson(x))
        .toList();
 
  }
}

class Appointment {
  late final int id;
  late final int number;
  late final int appointmentStatus;
  late final double deliveryFee;
  late final double totalPrices;
  late final double totalDiscounts;
  late final double couponDiscount;
  late final String paymentType;
  late final int paymentStatus;
  late final String reasonOfCancel;
  late final String date;
  late final String note;
  late final int userId;
  late final int addressId;
  late final int providerTypeId;
  late final String createdAt;
  late final String updatedAt;
  late final String statusText;
  late final String paymentStatusText;
  late final String bookingType;
  late final int totalCustomers;
  late final bool canFinish;
  late final bool requiresPaymentConfirmation;
  late final User user;
  late final Address address;
  late final ProviderType providerType;
  late final List<AppointmentService> appointmentServices;
  bool get isHourly => bookingType == 'hourly';

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    number = json["number"] ?? 0;
    appointmentStatus = json["appointment_status"] ?? 0;
    deliveryFee = (json["delivery_fee"] ?? 0).toDouble();
    totalPrices = (json["total_prices"] ?? 0).toDouble();
    totalDiscounts = (json["total_discounts"] ?? 0).toDouble();
    couponDiscount = (json["coupon_discount"] ?? 0).toDouble();
    paymentType = json["payment_type"] ?? '';
    paymentStatus = json["payment_status"] ?? 0;
    reasonOfCancel = json["reason_of_cancel"] ?? '';
    date = json["date"] ?? '';
    note = json["note"] ?? '';
    userId = json["user_id"] ?? 0;
    addressId = json["address_id"] ?? 0;
    providerTypeId = json["provider_type_id"] ?? 0;
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
    statusText = json["status_text"] ?? '';
    paymentStatusText = json["payment_status_text"] ?? '';
    bookingType = json["booking_type"] ?? '';
    totalCustomers = json["total_customers"] ?? 0;
    canFinish = json["can_finish"] ?? false;
    requiresPaymentConfirmation = json["requires_payment_confirmation"] ?? false;
    user = User.fromJson(json["user"] ?? {});
    address = Address.fromJson(json["address"] ?? {});
    providerType = ProviderType.fromJson(json["provider_type"] ?? {});
    appointmentServices = List.from(json["appointment_services"]??[])
        .map((x) => AppointmentService.fromJson(x))
        .toList();
  }
}

class AppointmentService {
  late final int id;
  late final int appointmentId;
  late final int serviceId;
  late final int customerCount;
  late final String servicePrice;
  late final String totalPrice;
  late final int personNumber;
  late final String createdAt;
  late final String updatedAt;
  late final ServiceDetail service;

  AppointmentService.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    appointmentId = json["appointment_id"] ?? 0;
    serviceId = json["service_id"] ?? 0;
    customerCount = json["customer_count"] ?? 0;
    servicePrice = json["service_price"] ?? '';
    totalPrice = json["total_price"] ?? '';
    personNumber = json["person_number"] ?? 0;
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
    service = ServiceDetail.fromJson(json["service"] ?? {});
  }
}

class ServiceDetail {
  late final int id;
  late final String nameEn;
  late final String nameAr;
  late final String createdAt;
  late final String updatedAt;
  late final String name;

  ServiceDetail.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    nameEn = json["name_en"] ?? '';
    nameAr = json["name_ar"] ?? '';
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
    name = json["name"] ?? '';
  }
}

class Type {
  late final int id;
  late final String nameEn;
  late final String nameAr;
  late final String photo;
  late final String bookingType;
  late final int haveDelivery;
  late final int minimumOrder;
  late final String createdAt;
  late final String updatedAt;
  late final String name;

  Type.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    nameEn = json["name_en"] ?? '';
    nameAr = json["name_ar"] ?? '';
    photo = json["photo"] ?? '';
    bookingType = json["booking_type"] ?? '';
    haveDelivery = json["have_delivery"] ?? 0;
    minimumOrder = json["minimum_order"] ?? 0;
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
    name = json["name"] ?? '';
  }
}

class Address {
  late final int id;
  late final String address;
  late final String lat;
  late final String lng;
  late final int userId;
  late final int deliveryId;
  late final String createdAt;
  late final String updatedAt;

  Address.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    address = json["address"] ?? '';
    lat = json["lat"] ?? '';
    lng = json["lng"] ?? '';
    userId = json["user_id"] ?? 0;
    deliveryId = json["delivery_id"] ?? 0;
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
  }
}

class ProviderType {
  late final int id;
  late final int providerId;
  late final int typeId;
  late final int activate;
  late final String name;
  late final String description;
  late final double lat;
  late final double lng;
  late final String address;
  late final int pricePerHour;
  late final int status;
  late final bool isVip;
  late final String createdAt;
  late final String updatedAt;
  late final int isFavourite;
  late final Type type;

  ProviderType.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    providerId = json["provider_id"] ?? 0;
    typeId = json["type_id"] ?? 0;
    activate = json["activate"] ?? 0;
    name = json["name"] ?? '';
    description = json["description"] ?? '';
    lat = (json["lat"] ?? 0).toDouble();
    lng = (json["lng"] ?? 0).toDouble();
    address = json["address"] ?? '';
    pricePerHour = json["price_per_hour"] ?? 0;
    status = json["status"] ?? 0;
    isVip = json["is_vip"] ?? false;
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
    isFavourite = json["is_favourite"] ?? false;
    type = Type.fromJson(json["type"] ?? {});
  }
}

class User {
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final String photo;
  late final String photoUrl;

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? '';
    phone = json["phone"] ?? '';
    email = json["email"] ?? '';
    photo = json["photo"] ?? '';
    photoUrl = json["photo_url"] ?? '';
  }
}

class Link {
  late final String url;
  late final String label;
  late final bool active;

  Link.fromJson(Map<String, dynamic> json) {
    url = json["url"] ?? '';
    label = json["label"] ?? '';
    active = json["active"] ?? false;
  }
}