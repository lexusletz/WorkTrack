import 'package:intl/intl.dart';

class AppDateUtils {
  static String getFormattedDate(DateTime date) {
    final String year = date.year.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString();

    final String localizedDay = DateFormat("EEE", "es").format(date);

    return "$day.$month.$year • ${localizedDay.toUpperCase()}";
  }

  static String getRemainingTime(DateTime time) {
    final Duration difference = time.difference(DateTime.now());

    if (difference.isNegative) {
      return "0 days, 0 hours, 0 minutes, 0 seconds";
    }

    final int days = difference.inDays;
    final int hours = difference.inHours.remainder(24);
    final int minutes = difference.inMinutes.remainder(60);
    final int seconds = difference.inSeconds.remainder(60);

    return "$days days, $hours hours, $minutes minutes, $seconds seconds";
  }
}
