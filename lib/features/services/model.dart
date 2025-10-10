part of "bloc.dart";

class ServicesModel {

  late final List<Service> list;

  ServicesModel.fromJson(Map<String, dynamic> json) {

    list = List.from(json["data"] ?? [])
        .map((x) => Service.fromJson(x))
        .toList();
  }
}

class Service {
  late final int id;
  late final String nameEn;
  late final String nameAr;
  late final String createdAt;
  late final String updatedAt;
  late final String name;

  Service.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    nameEn = json["name_en"] ?? '';
    nameAr = json["name_ar"] ?? '';
    createdAt = json["created_at"] ?? '';
    updatedAt = json["updated_at"] ?? '';
    name = json["name"] ?? '';
  }
}