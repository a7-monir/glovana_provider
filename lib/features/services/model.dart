part of "bloc.dart";

class ServicesModel {

  late final List<Service2> list;

  ServicesModel.fromJson(Map<String, dynamic> json) {

    list = List.from(json["data"] ?? [])
        .map((x) => Service2.fromJson(x))
        .toList();
  }
}

