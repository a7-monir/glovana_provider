part of 'bloc.dart';
class RatingData {
  late final bool status;
  late final String message;
  late final List<RatingModel> data;

  RatingData.fromJson(Map<String, dynamic> json) {
    status = json["status"] ?? false;
    message = json["message"] ?? '';
    data = List.from(json["data"] ?? [])
        .map((x) => RatingModel.fromJson(x))
        .toList();
  }
}

class RatingModel {
  late final int id;
  late final String review;
  late final double rating;
  late final User user;

  RatingModel.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    review = json["review"] ?? '';
    rating = (json["rating"] ?? 0).toDouble();
    user = json["user"] != null
        ? User.fromJson(json["user"])
        : User.fromJson({});
  }
}

class User {
  late final int id;
  late final String name;
  late final String photoUrl;

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? '';
    photoUrl = json["photo_url"] ?? '';
  }
}