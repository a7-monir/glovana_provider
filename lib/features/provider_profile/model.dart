
part of 'bloc.dart';
class ProviderProfileData {

  late final bool status;
  late final String message;
  late final Data data;

  ProviderProfileData.fromJson(Map<String, dynamic> json){

    data = Data.fromJson(json['data']??{});
  }

}

class Data {

  late final Provider provider;

  Data.fromJson(Map<String, dynamic> json){
    provider = Provider.fromJson(json['provider']??{});
  }

}

class Provider {

  late final int id;
  late final String nameOfManager;
  late final String countryCode;
  late final String phone;
  late final String email;
  late final String photoOfManager;
  late final String fcmToken;
  late final num balance;
  late final num totalPoints;
  late final int activate;
  late final String createdAt;
  late final String updatedAt;
  late final String photoUrl;
  late final List<ProviderTypes> providerTypes;

  Provider.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    nameOfManager = json['name_of_manager']??'';
    countryCode = json['country_code']??'';
    phone = json['phone']??0;
    email = json['email']??'';
    photoOfManager = json['photo_of_manager']??'';
    fcmToken = json['fcm_token']??'';
    balance = json['balance']??0;
    totalPoints = json['total_points']??0;
    activate = json['activate']??0;
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
    photoUrl = json['photo_url']??'';
    providerTypes = List.from(json['provider_types']).map((e)=>ProviderTypes.fromJson(e)).toList();
  }
}

class ProviderTypes {

  late final int id;
  late final int providerId;
  late final int typeId;
  late final int activate;
  late final String name;
  late final String description;
  late final num lat;
  late final num lng;
  late final String practiceLicense;
  late final String identityPhoto;
  late final String address;
  late final num pricePerHour,numberOfWork;
  late final int status;
  late final bool isVip;
  late final String createdAt,phoneNumberOfProviderType;
  late final String updatedAt;
  late final bool isFavourite;
  late final Type type;
  late final List<Services> services;
  late final List<ProviderServices> providerServices;
  late final List<Images> images;
  late final List<Galleries> galleries;
  late final List<Availabilities> availabilities;

  ProviderTypes.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    providerId = json['provider_id']??0;
    typeId = json['type_id']??0;
    activate = json['activate']??0;
    name = json['name']??'';
    description = json['description']??'';
    lat = json['lat']??0;
    lng = json['lng']??0;
    practiceLicense = json['practice_license']??'';
    identityPhoto = json['identity_photo']??'';
    address = json['address']??'';
    pricePerHour = json['price_per_hour']??0;
    phoneNumberOfProviderType = json['phone_number_of_provider_type']??'';
    numberOfWork = json['number_of_work']??0;
    status = json['status']??0;
    isVip = json['is_vip']??false;
    createdAt = json['created_at']??'0';
    updatedAt = json['updated_at']??'0';
    isFavourite = json['is_favourite']??false;
    type = Type.fromJson(json['type']??{});
    services = List.from(json['services']??[]).map((e)=>Services.fromJson(e)).toList();
    providerServices = List.from(json['provider_services']??[]).map((e)=>ProviderServices.fromJson(e)).toList();
    images = List.from(json['images']??[]).map((e)=>Images.fromJson(e)).toList();
    galleries = List.from(json['galleries']??[]).map((e)=>Galleries.fromJson(e)).toList();
    availabilities = List.from(json['availabilities']??[]).map((e)=>Availabilities.fromJson(e)).toList();
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
    id = json['id'] ?? 0;
    nameEn = json['name_en'] ?? '';
    nameAr = json['name_ar'] ?? '';
    photo = json['photo'] ?? '';
    bookingType = json['booking_type'] ?? '';
    haveDelivery = json['have_delivery'] ?? 0;
    minimumOrder = json['minimum_order'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    name = json['name'] ?? '';
  }
}

class Services {
  late final int id;
  late final int providerTypeId;
  late final int serviceId;
  late final String createdAt;
  late final String updatedAt;

  Services.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    providerTypeId = json['provider_type_id'] ?? 0;
    serviceId = json['service_id'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }
}

class ProviderServices {
  late final int id;
  late final int providerTypeId;
  late final int serviceId;
  late final String price;
  late final int isActive;
  late final String createdAt;
  late final String updatedAt;
  late final Service2 service;

  ProviderServices.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    providerTypeId = json['provider_type_id'] ?? 0;
    serviceId = json['service_id'] ?? 0;
    price = json['price'] ?? '';
    isActive = json['is_active'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    service = Service2.fromJson(json['service'] ?? {});
  }
}

class Service2 {
  late final int id;
  late final String nameEn;
  late final String nameAr;
  late final String createdAt;
  late final String updatedAt;
  late final String name;

  Service2.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    nameEn = json['name_en'] ?? '';
    nameAr = json['name_ar'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    name = json['name'] ?? '';
  }


}

class Images {
  late final int id;
  late final int providerTypeId;
  late final String photo;
  late final String createdAt;
  late final String updatedAt;
  late final String photoUrl;

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    providerTypeId = json['provider_type_id'] ?? 0;
    photo = json['photo'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    photoUrl = json['photo_url'] ?? '';
  }


}

class Galleries {
  late final int id;
  late final int providerTypeId;
  late final String photo;
  late final String createdAt;
  late final String updatedAt;
  late final String photoUrl;

  Galleries.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    providerTypeId = json['provider_type_id'] ?? 0;
    photo = json['photo'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    photoUrl = json['photo_url'] ?? '';
  }


}

class Availabilities {
  late final int id;
  late final int providerTypeId;
  late final String dayOfWeek;
  late final String startTime;
  late final String endTime;
  late final String createdAt;
  late final String updatedAt;

  Availabilities.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    providerTypeId = json['provider_type_id'] ?? 0;
    dayOfWeek = json['day_of_week'] ?? '';
    startTime = json['start_time'] ?? '';
    endTime = json['end_time'] ?? '';
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['provider_type_id'] = providerTypeId;
    _data['day_of_week'] = dayOfWeek;
    _data['start_time'] = startTime;
    _data['end_time'] = endTime;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}