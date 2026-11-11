import 'cache_helper.dart';

class TextHelper {
  static String text(arabName, englishName) {
    if (CacheHelper.lang == "en") {
      if (englishName.isEmpty) {
        return arabName;
      }
      return englishName;
    } else {
      if (arabName.isEmpty) {
        return englishName;
      }
      return arabName;
    }
  }

  // static String toDate(String text) {
  //   return DateFormat().().parse(text);
}
