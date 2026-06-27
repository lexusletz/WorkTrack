import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/notifications/notification_repository.dart';
import '../../../core/utils/date_utils.dart';
import '../../../l10n/app_localizations.dart';

class InstallationTime extends StatefulWidget {
  const InstallationTime({super.key});

  @override
  State<InstallationTime> createState() => _InstallationTimeState();
}

class _InstallationTimeState extends State<InstallationTime> {
  final Logger _logger = Logger("InstallationTime");

  static const platform = MethodChannel(
    "io.github.lexusletz.worktrack/installation",
  );

  DateTime? _installationTime;
  DateTime? _expirationTime;

  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    _getInstallationDate();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getInstallationDate() async {
    if (!Platform.isIOS) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final timestamp =
          await platform.invokeMethod<int>("getBinaryCreationDate") ?? -1;

      _installationTime =
          DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      _expirationTime = _installationTime!.add(const Duration(days: 7));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          'installation_timestamp', _installationTime!.millisecondsSinceEpoch);
      await prefs.setInt(
          'expiration_timestamp', _expirationTime!.millisecondsSinceEpoch);

      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final l10n = AppLocalizations.of(context)!;
          NotificationRepository.scheduleReinstallReminder(
            expirationDate: _expirationTime!,
            l10n: l10n,
          );
        });
      }
    } on PlatformException catch (e) {
      _logger.severe("Error obtaining the installation time: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return const SizedBox.shrink();
    }

    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    final l10n = AppLocalizations.of(context)!;
    final installDate = _installationTime;
    final expireDate = _expirationTime;

    if (installDate == null || expireDate == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${l10n.installationDateLabel}${DateFormat("d/M/y, h:mm a").format(installDate)}",
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          "${l10n.expirationDateLabel}${DateFormat("d/M/y, h:mm a").format(expireDate)}",
          style: const TextStyle(color: Colors.white),
        ),
        Text(
          "${l10n.remainingTimeLabel}${AppDateUtils.getRemainingTime(expireDate)}",
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
