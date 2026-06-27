import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final installationTimestampProvider = FutureProvider<DateTime?>((ref) async {
  if (!Platform.isIOS) return null;

  try {
    const platform = MethodChannel(
      "io.github.lexusletz.worktrack/installation",
    );

    final timestamp =
        await platform.invokeMethod<int>("getBinaryCreationDate") ?? -1;

    final installTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final expirationTime = installTime.add(const Duration(days: 7));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        'installation_timestamp', installTime.millisecondsSinceEpoch);
    await prefs.setInt(
        'expiration_timestamp', expirationTime.millisecondsSinceEpoch);

    return installTime;
  } catch (e) {
    return null;
  }
});
