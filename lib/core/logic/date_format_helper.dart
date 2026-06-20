import 'package:intl/intl.dart';

class DateFormatHelper {
  static DateTime parseApiDate(String? date) {
    final parsedDate = DateTime.tryParse(date ?? '');

    if (parsedDate == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return parsedDate.isUtc ? parsedDate.toLocal() : parsedDate;
  }

  static String shape1(String date) {
    String newDate = "";
    if (date.isNotEmpty) {
      final oldDate = parseApiDate(date);
      if (oldDate.hour > 0) {
        newDate = DateFormat("dd MMM y At ").add_jm().format(oldDate);
      } else {
        newDate = DateFormat("dd MMM y").format(oldDate);
      }
    }
    return newDate;
  }
}
