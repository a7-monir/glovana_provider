import 'package:shared_preferences/shared_preferences.dart';

import '../../features/login/bloc.dart' show User;

class CacheHelper {
  static late SharedPreferences _ref;

  static Future<void> init() async {
    _ref = await SharedPreferences.getInstance();
  }

  static String get lang => _ref.getString('lang') ?? 'en';
  static Future<void> setLang(String value) async => _ref.setString('lang', value);

  static bool get isFirstTime => _ref.getBool('isFirstTime') ?? true;
  static Future<void> setNotFirstTime() async => _ref.setBool('isFirstTime', false);

  static String get token => _ref.getString('token') ?? '';
  static Future<void> setToken(String value) async => _ref.setString('token', value);

  /// Consider a user "authed" if we have a non-empty token AND a non-zero id.
  static bool get isAuthed => token.isNotEmpty && id != 0;

  static int get id => _ref.getInt('id') ?? 0;
  static Future<void> setId(int value) async => _ref.setInt('id', value);

  static String get phone => _ref.getString('phone') ?? '';
  static Future<void> setPhone(String value) async => _ref.setString('phone', value);

  static String get email => _ref.getString('email') ?? '';
  static Future<void> setEmail(String value) async => _ref.setString('email', value);

  static String get name => _ref.getString('name') ?? '';
  static Future<void> setName(String value) async => _ref.setString('name', value);

  static String get photo => _ref.getString('photo') ?? '';
  static Future<void> setPhoto(String value) async => _ref.setString('photo', value);

  static String get referralCode => _ref.getString('referralCode') ?? '';
  static String get createdAt => _ref.getString('createdAt') ?? '';
  static String get updatedAt => _ref.getString('updatedAt') ?? '';

  static num get balance => _ref.getNum('balance') ?? 0;
  static Future<void> setBalance(num value) async => _ref.setString('balance', value.toString());

  static String get fcmToken => _ref.getString('fcmToken') ?? '';
  static Future<void> setFcmToken(String value) async => _ref.setString('fcmToken', value);

  // ---------- address / misc ----------
  static String get addressName => _ref.getString('addressName') ?? '';
  static Future<void> setAddressName(String value) async => _ref.setString('addressName', value);

  static String get addressLat => _ref.getString('addressLat') ?? '';
  static Future<void> setAddressLat(String value) async => _ref.setString('addressLat', value);

  static String get addressLng => _ref.getString('addressLng') ?? '';
  static Future<void> setAddressLng(String value) async => _ref.setString('addressLng', value);

  static int get addressId => _ref.getInt('addressId') ?? 0;
  static Future<void> setAddressId(int value) async => _ref.setInt('addressId', value);

  static int get deliveryPrice => _ref.getInt('deliveryPrice') ?? 0;
  static Future<void> setDeliveryPrice(int value) async => _ref.setInt('deliveryPrice', value);

  // ---------- generic helpers ----------
  static Future<void> setValue(String key, String value) async => _ref.setString(key, value);
  static dynamic getData({required String key}) => _ref.get(key);

  /// Save user model fields (NOT the token).
  static Future<void> saveData(User model) async {
    // debug
    // print('************** Save the data *****************');
    await _ref.setInt('id', model.id);
    await _ref.setString('phone', model.phone);
    await _ref.setString('email', model.email);
    await _ref.setString('name', model.name);
    await _ref.setString('fcmToken', model.fcmToken);
    await _ref.setString('createdAt', model.createdAt);
    await _ref.setString('updatedAt', model.updatedAt);
    await _ref.setString('referralCode', model.referralCode);
    await _ref.setString('photo', model.photo);
    await _ref.setString('balance', model.balance.toString());
  }

  /// Clear everything but preserve language + first-time flag.
  static Future<void> logOut() async {
    final keepLang = lang;
    await _ref.clear();
    await setLang(keepLang);
    await setNotFirstTime();
  }
}

extension on SharedPreferences {
  num? getNum(String key) {
    final v = getString(key);
    if (v == null) return null;
    return num.tryParse(v);
  }
}
