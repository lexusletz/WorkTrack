import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/sync/device_discovery_service.dart';
import 'core/sync/paired_devices_repository.dart';
import 'core/sync/sync_orchestrator.dart';
import 'core/sync/sync_providers.dart';
import 'core/sync/sync_service.dart';
import 'core/theme/app_theme.dart';
import 'core/updater/updater_providers.dart';
import 'l10n/app_localizations.dart';
import 'core/settings/settings_providers.dart';
import 'core/worklog/worklog_model.dart';
import 'core/worklog/worklog_providers.dart';
import 'core/worklog/worklog_repository.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await Hive.initFlutter();
  Hive.registerAdapter(WorkLogAdapter());
  final worklogBox = await Hive.openBox<WorkLog>('worklogs');

  final packageInfo = await PackageInfo.fromPlatform();

  final syncOrchestrator = SyncOrchestrator(
    discovery: DeviceDiscoveryService(),
    pairedRepo: PairedDevicesRepository(prefs),
    syncService: SyncService(
      worklogRepo: WorkLogRepository(worklogBox),
      prefs: prefs,
    ),
  );
  await syncOrchestrator.initialize();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalShortestSide = view.physicalSize.shortestSide / view.devicePixelRatio;

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

  // Hide system UI (status bar, navigation bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsProvider.overrideWithValue(prefs),
        worklogBoxProvider.overrideWithValue(worklogBox),
        packageInfoProvider.overrideWithValue(packageInfo),
        syncOrchestratorProvider.overrideWithValue(syncOrchestrator),
      ],
      child: const WorkTrackApp(),
    ),
  );
}

class WorkTrackApp extends ConsumerWidget {
  const WorkTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = AppTheme.build(ref);

    return MaterialApp(
      title: 'WorkTrack',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      home: const DashboardScreen(),
    );
  }
}
