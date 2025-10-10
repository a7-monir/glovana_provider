import 'cache_helper.dart';

class TextHelper {
  static String text(_arabName, _englishName) {
    if (CacheHelper.lang == "en") {
      if (_englishName.isEmpty) {
        return _arabName;
      }
      return _englishName;
    } else {
      if (_arabName.isEmpty) {
        return _englishName;
      }
      return _arabName;
    }
  }

  // static String toDate(String text) {
  //   return DateFormat().().parse(text);
}
