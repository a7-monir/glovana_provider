
part of 'bloc.dart';

class UserData {
  late final UserModel userModel;

  UserData.fromJson(Map<String, dynamic> json) {
    userModel = UserModel.fromJson(json['data'] ?? {});
  }
}

class UserModel {
  late final String token;
  late final User user;

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'] ?? "";
    user = User.fromJson(json['user'] ?? {});
  }
}

class User {
  late final int id;
  late final String name,
      countryCode,
      phone,
      email,
      password,
      fcmToken,
      referralCode,
      accessToken,
      createdAt,
      updatedAt,
      photoUrl;
  late final num balance,
      totalPoints,
      activate,
      userId,
      googleId,
      appleId,
      type;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name_of_manager'] ?? json['name']??'';
    countryCode = json['country_code'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    password = json['password'] ?? '';
    fcmToken = json['fcmToken'] ?? '';
    balance = json['balance'] ?? 0;
    totalPoints = json['total_points'] ?? 0;
    referralCode = json['referral_code'] ?? '';
    activate = json['activate'] ?? 0;
    userId = json['userId'] ?? 0;
    googleId = json['googleId'] ?? 0;
    appleId = json['appleId'] ?? 0;
    accessToken = json['accessToken'] ?? '';
    type = json['type'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
    photoUrl = json['photo_url'] ?? '';
  }
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_code": countryCode,
    "phone": phone,
    "email": email,
    "password": password,
    "fcm_token": fcmToken,
    "balance": balance,
    "referral_code": referralCode,
    "activate": activate,
    "user_id": userId,
    "created_at": createdAt?.toString(),
    "updated_at": updatedAt?.toString(),
    "photo_url": photoUrl,
  };
}

UserResponseModel userResponseModelFromJson(String str) =>
    UserResponseModel.fromJson(json.decode(str));

String userResponseModelToJson(UserResponseModel data) =>
    json.encode(data.toJson());

class UserResponseModel {
  bool? status;
  String? message;
  Data? data;

  UserResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) =>
      UserResponseModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? token;
  User? user;

  Data({
    this.token,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user?.toJson(),
  };
}