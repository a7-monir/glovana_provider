
import 'package:flutter/cupertino.dart';
import 'package:glovana_provider/core/logic/cache_helper.dart';

class Constants {
  static double getHeight(context) => MediaQuery.of(context).size.height;
  static double getwidth(context) => MediaQuery.of(context).size.width;
  static String lang = CacheHelper.getData(key: 'lang') ?? 'en';
  static String? token = CacheHelper.getData(key: 'jwt');
  static String userName = CacheHelper.getData(key: 'user_name') ?? '';
  static String image = CacheHelper.getData(key: 'image') ?? '';
  static String password = CacheHelper.getData(key: 'pass') ?? '';
  static int userType = CacheHelper.getData(key: 'user_type') ?? 0;

  static bool showedIntro = CacheHelper.getData(key: 'show_intro') ?? true;

  static const kUserData = 'kUserData';

  static const String kToken = 'kToken';
}
