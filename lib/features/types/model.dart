part of "bloc.dart";

class TypeData {
  late final List<TypeModel> list;

  TypeData.fromJson(Map<String, dynamic> json) {
    list = List.from(json['data'] ?? []).map((e) => TypeModel.fromJson(e)).toList();
  }
}

class TypeModel {
  late final int id,haveDelivery, minimumOrder;
  late final String nameEn, nameAr, photo, bookingType, createdAt, updatedAt, name;
  TypeModel({required this.id,required this.name,required this.bookingType});

  TypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id']??0;
    nameEn = json['name_en']??'';
    nameAr = json['name_ar']??'';
    photo = json['photo']??'';
    bookingType = json['booking_type']??'';
    haveDelivery = json['have_delivery']??0;
    minimumOrder = json['minimum_order']??0;
    createdAt = json['created_at']??'';
    updatedAt = json['updated_at']??'';
    name = json['name']??'';
  }
}
