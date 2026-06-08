import 'package:intl/intl.dart';

class AppDateUtils {
  static String getFormattedDate(DateTime date) {
    final String year = date.year.toString();
    final String month = date.month.toString();
    final String day = date.day.toString();

    final String localizedDay = DateFormat("EEE").format(date);

    return "$year.$month.$day • ${localizedDay.toUpperCase()}";
  }
}
