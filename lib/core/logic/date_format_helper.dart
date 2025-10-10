import 'package:intl/intl.dart';

class DateFormatHelper {

  static String shape1(String date) {
    //date came like this 2020-12-27T00:00:00
    String newDate = "";
    if (date.isNotEmpty) {
      final oldDate = DateTime.parse(date);
      if (oldDate.hour > 0) {
        newDate = DateFormat("dd MMM y At ").add_jm().format(oldDate);
      } else {
        newDate = DateFormat("dd MMM y").format(oldDate);
      }
    }
    return newDate;
  }
}
