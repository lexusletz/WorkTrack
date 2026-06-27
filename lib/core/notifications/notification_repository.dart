import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../l10n/app_localizations.dart';

class NotificationRepository {
  static FlutterLocalNotificationsPlugin? _plugin;
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    _plugin = FlutterLocalNotificationsPlugin();

    const iosSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(iOS: iosSettings);

    await _plugin!.initialize(settings: initSettings);
    _initialized = true;

    await requestNotificationPermission();
  }

  static Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (!status.isGranted) {
      status = await Permission.notification.request();
      if (status.isGranted) {
        debugPrint("Notification permission granted");
      } else {
        debugPrint("Notification permission denied");
      }
    }
  }

  static Future<void> scheduleReinstallReminder({
    required DateTime expirationDate,
    required AppLocalizations l10n,
  }) async {
    if (_plugin == null) return;

    final prefs = await SharedPreferences.getInstance();
    final savedExpiration = prefs.getInt('expiration_timestamp');

    if (savedExpiration != null &&
        savedExpiration == expirationDate.millisecondsSinceEpoch) {
      return;
    }

    await _plugin!.cancel(id: 1);
    await _plugin!.cancel(id: 2);

    final now = DateTime.now();
    final dayBefore = expirationDate.subtract(const Duration(days: 1));

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    if (dayBefore.isAfter(now)) {
      await _plugin!.zonedSchedule(
        id: 1,
        title: l10n.sideloadExpiringSoonTitle,
        body: l10n.sideloadExpiringSoonBody,
        scheduledDate: tz.TZDateTime.from(dayBefore, tz.local),
        notificationDetails: NotificationDetails(iOS: iosDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    if (expirationDate.isAfter(now)) {
      await _plugin!.zonedSchedule(
        id: 2,
        title: l10n.sideloadExpiredTitle,
        body: l10n.sideloadExpiredBody,
        scheduledDate: tz.TZDateTime.from(expirationDate, tz.local),
        notificationDetails: NotificationDetails(iOS: iosDetails),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }

    await prefs.setInt(
        'expiration_timestamp', expirationDate.millisecondsSinceEpoch);
  }
}
