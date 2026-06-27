import 'package:intl/intl.dart';

class AppDateUtils {
  static String getFormattedDate(DateTime date) {
    final String year = date.year.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String day = date.day.toString();

    final String localizedDay = DateFormat("EEE", "es").format(date);

    return "$day.$month.$year • ${localizedDay.toUpperCase()}";
  }

  static double getElapsedRatio(DateTime install, DateTime expire) {
    final total = expire.difference(install);
    if (total.inMicroseconds <= 0) return 1.0;
    final elapsed = DateTime.now().difference(install);
    return (elapsed.inMicroseconds / total.inMicroseconds).clamp(0.0, 1.0);
  }

  static String getCompactRemaining(DateTime time) {
    final difference = time.difference(DateTime.now());

    if (difference.isNegative) return "0 days";

    final days = difference.inDays;
    final hours = difference.inHours.remainder(24);

    if (days > 0) {
      return "$days day${days == 1 ? '' : 's'} remaining";
    }
    return "$hours hour${hours == 1 ? '' : 's'} remaining";
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
