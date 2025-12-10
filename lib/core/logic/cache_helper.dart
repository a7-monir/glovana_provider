import 'package:shared_preferences/shared_preferences.dart';

import '../../features/login/bloc.dart' show User;


class CacheHelper {
  static late SharedPreferences _ref;

  static Future<void> init() async {
    _ref = await SharedPreferences.getInstance();
  }

  static String get lang {
    return _ref.getString("lang") ?? "en";
  }

  static String get token {
    return _ref.getString("token") ?? "";

    return _ref.getString("token") ??
        "3|m6YT2owf8HcG4JXUZZ4OyF55vkqjT7AohAbpo1wD8834d6b9";
  }

  static String get phone {
    return _ref.getString("phone") ?? "";
  }

  //
  // static String get phone {
  //   if(phone.startsWith('+962')){
  //      return phone.replaceRange(0, 4, '');
  //   }else{
  //     return phone;
  //   }
  //
  // }

  static String get email {
    return _ref.getString("email") ?? "";
  }

  static String get name {
    return _ref.getString("name") ?? "";
  }

  static String get photo {
    return _ref.getString("photo") ?? "";
  }

  static String get referralCode {
    return _ref.getString("referralCode") ?? "";
  }

  static String get createdAt {
    return _ref.getString("createdAt") ?? "";
  }

  static String get updatedAt {
    return _ref.getString("updatedAt") ?? "";
  }

  static int get id {
    return _ref.getInt("id") ?? 0;
  } static int get activate {
    return _ref.getInt("activate") ?? 0;
  }

  static int get balance {
    return _ref.getInt("id") ?? 0;
  }

  static bool get isAuthed {
    return token.isNotEmpty;
  }

  static Future<void> setIsAuthed() async {
    _ref.setBool("isAuthed", true);
  }

  static bool get isFirstTime {
    return _ref.getBool("isFirstTime") ?? true;
  }

  static Future<void> setNotFirstTime() async {
    _ref.setBool("isFirstTime", false);
  }

  static Future<void> setLang(String lang) async {
    _ref.setString("lang", lang);
  }

  static Future<void> setToken(String token) async {
    print("Token Saved $token");
    await _ref.setString("token", token);
  }

  static Future<void> setAddressName(String addressName) async {
    await _ref.setString("addressName", addressName);
  }

  static String get addressName {
    return _ref.getString("addressName") ?? "";
  }

  static Future<void> setAddressLat(String addressLat) async {
    await _ref.setString("addressLat", addressLat);
  }

  static String get addressLat {
    return _ref.getString("addressLat") ?? "";
  }

  static Future<void> setAddressLng(String addressLng) async {
    await _ref.setString("addressLng", addressLng);
  }

  static String get addressLng {
    return _ref.getString("addressLng") ?? "";
  }

  static Future<void> setAddressId(int addressId) async {
    await _ref.setInt("addressId", addressId);
  }

  static Future<void> setDeliveryPrice(int deliveryPrice) async {
    await _ref.setInt("deliveryPrice", deliveryPrice);
  }

  static int get deliveryPrice {
    return _ref.getInt('deliveryPrice') ?? 0;
  }

  static int get addressId {
    return _ref.getInt('addressId') ?? 0;
  }

  static Future<void> setValue(String key, String value) async {
    await _ref.setString(key, value);
  }
  static getData({required String key}) {
    return _ref.get(key);
  }

  static Future<void> saveData(User model) async {
    print("************** Save the data *****************");
    await _ref.setInt("id", model.id);
    await _ref.setString("phone", model.phone);
    await _ref.setString("email", model.email);
    await _ref.setString("name", model.name);
    await _ref.setString("fcmToken", model.fcmToken);
    await _ref.setString("createdAt", model.createdAt);
    await _ref.setString("updatedAt", model.updatedAt);
    await _ref.setString("referralCode", model.referralCode);
    await _ref.setString("photo", model.photoUrl);
    await _ref.setInt("balance", model.balance.toInt());
    await _ref.setInt("balance", model.balance.toInt());
    await _ref.setInt("activate", model.activate.toInt());
  }

  static Future<void> logOut() async {
    await _ref.clear();
    await setNotFirstTime();
    await setLang(lang);
  }
}
