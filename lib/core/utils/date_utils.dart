import 'package:intl/intl.dart';

class AppDateUtils {
  static String getFormattedDate(DateTime date) {
    final String year = date.year.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString();

    final String localizedDay = DateFormat("EEE", "es").format(date);

    return "$day.$month.$year • ${localizedDay.toUpperCase()}";
  }
}
