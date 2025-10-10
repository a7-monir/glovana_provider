part of "bloc.dart";

class AddressData {
  late final List<AddressModel> list;

  AddressData.fromJson(Map<String, dynamic> json) {
    list = List.from(json['data'] ?? []).map((e) => AddressModel.fromJson(e)).toList();
  }
}

class AddressModel {
  late final String  address, lat, lng, updatedAt,createdAt;
  late final int id,userId,deliveryId;
  late final Delivery delivery;

  AddressModel({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
});
  AddressModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id']??0;
    address = json['address']??'';
    lat = json['lat']??'';
    lng = json['lng']??'';
    deliveryId = json['delivery_id']??0;
    updatedAt = json['updated_at']??'';
    createdAt = json['created_at']??'';
    id = json['id']??0;
    delivery = Delivery.fromJson(json['delivery']??{});
  }

}
class Delivery {

  late final int id,price;
  late final String place, createdAt, updatedAt;

  Delivery.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    place = json['place']??'';
    price = json['price']??0;
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
  }

}
