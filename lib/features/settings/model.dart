part of "bloc.dart";

class SettingsModel {

  late final List<Data> data;

  SettingsModel.fromJson(Map<String, dynamic> json){
    data = List.from(json['data']??[]).map((e)=>Data.fromJson(e)).toList();
  }

}

class Data {

  late final int id;
  late final String key;
  late final num value;


  Data.fromJson(Map<String, dynamic> json){
    id = json['id']??0;
    key = json['key']??'';
    value = json['value']??0;

  }


}
