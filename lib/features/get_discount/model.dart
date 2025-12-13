part of 'bloc.dart';

class DiscountData {

  late final Data data;

  DiscountData.fromJson(Map<String, dynamic> json){

    data = Data.fromJson(json['data']??{});
  }


}

class Data {

  late final List<Discounts> discounts;


  Data.fromJson(Map<String, dynamic> json){

    discounts = List.from(json['discounts']).map((e)=>Discounts.fromJson(e)).toList();

  }


}


class Discounts {
  late final int id;
  late final int providerTypeId;
  late final String name;
  late final String description;
  late final String percentage;
  late final String startDate;
  late final String endDate;
  late final String discountType;
  late final bool isActive;
  late final String createdAt;
  late final String updatedAt;
  late final String currentStatus;
  late final List<Services> services;

  Discounts.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    providerTypeId = json['provider_type_id']??0;
    name = json['name']??'';
    description = json['description']??'';
    percentage = json['percentage']??'';
    startDate = json['start_date']??'';
    endDate = json['end_date']??'';
    discountType = json['discount_type']??'';
    isActive = json['is_active']??false;
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
    currentStatus = json['current_status'];
    services = List.from(json['services']??[]).map((e)=>Services.fromJson(e)).toList();
  }
}

class Services {

  late final int id;
  late final String nameEn;
  late final String nameAr;
  late final String createdAt;
  late final String updatedAt;
  late final String name;
  late final Pivot pivot;

  Services.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    nameEn = json['name_en']??'';
    nameAr = json['name_ar']??'';
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
    name = json['name']??'';
    pivot = Pivot.fromJson(json['pivot']??{});
  }

}

class Pivot {

  late final int discountId;
  late final int serviceId;

  Pivot.fromJson(Map<String, dynamic> json){
    discountId = json['discount_id']??0;
    serviceId = json['service_id']??0;
  }

}

class CurrentPricing {

  late final List<Services> services;

  CurrentPricing.fromJson(Map<String, dynamic> json){
    services = List.from(json['services']??[]).map((e)=>Services.fromJson(e)).toList();
  }

}