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
      photo,
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
    photo = json['photo']??json['photoUrl']?? '';
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
    photoUrl = json['photoUrl'] ?? '';
  }
}
