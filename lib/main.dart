import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/notifications/notification_repository.dart';
import 'core/preferences/providers/preferences_providers.dart';
import 'core/theme/app_theme.dart';
import 'core/updater/updater_providers.dart';
import 'core/utils/globals.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/preferences/widgets/preferences_listener.dart';
import 'l10n/app_localizations.dart';
import 'core/worklog/worklog_model.dart';
import 'core/worklog/worklog_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final results = await Future.wait([
    // FIXME: Move this to when the user really needs to enable notifications,
    //       or when we ask for it
    //
    NotificationRepository.initialize(),
    SharedPreferences.getInstance(),
    _initHive(),
    PackageInfo.fromPlatform(),
  ]);

  // FIXME: We could do the same as in line 8-9. We only use this when programing
  //        notification, so, why load it on the first start?
  //
  // tz.initializeTimeZones();

  final prefs = results[1] as SharedPreferences;
  final worklogBox = results[2] as Box<WorkLog>;
  final packageInfo = results[3] as PackageInfo;

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalShortestSide =
      view.physicalSize.shortestSide / view.devicePixelRatio;

  if (logicalShortestSide < 600) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        worklogBoxProvider.overrideWithValue(worklogBox),
        packageInfoProvider.overrideWithValue(packageInfo),
      ],
      child: const WorkTrackApp(),
    ),
  );
}

Future<Box<WorkLog>> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkLogAdapter());
  return Hive.openBox<WorkLog>('worklogs');
}

class WorkTrackApp extends ConsumerWidget {
  const WorkTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.build(ref);

    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'WorkTrack',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: DashboardScreen(),
      builder: (context, child) {
        return PreferencesListener(child: child ?? SizedBox.shrink());
      },
    );
  }
}
