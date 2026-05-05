import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/updater/updater_providers.dart';
import '../../l10n/app_localizations.dart';
import '../settings/settings_dialog.dart';
import '../sync/devices_screen.dart';
import '../updater/updater_dialog.dart';
import 'widgets/forecast_header.dart';
import 'widgets/month_navigator.dart';
import 'widgets/calendar_grid.dart';
import 'widgets/day_editor_panel.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(updaterProvider.notifier).checkForUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    ref.listen(updaterProvider, (previous, next) async {
      if (next.hasNewVersion) {
        await showDialog<void>(
          context: context,
          builder: (_) => UpdaterDialog(
            version: next.newVersion,
            onUpdateSelected: () {
              Navigator.of(context).pop();
              ref.read(updaterProvider.notifier).downloadAndInstallUpdate();
            },
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/icon/icon.png', width: 48, height: 48),
            const SizedBox(width: 10),
            Text(l10n.dashboardTitle),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.devices),
            tooltip: 'Dispositivos',
            onPressed: () => {
              if (Platform.isAndroid)
                {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DevicesScreen(),
                    ),
                  ),
                }
              else
                {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Sincronización no disponible en esta plataforma",
                      ),
                    ),
                  ),
                },
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settingsDialogTitle,
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const SettingsDialog(),
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20)
                )
              )
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ForecastHeader(),
          Divider(
            thickness: 0.4,
            color: Theme.of(context).colorScheme.primary.withAlpha(90),
          ),
          MonthNavigator(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 2, child: CalendarGrid()),
                if (MediaQuery.of(context).size.width >= 600)
                  Container(
                    constraints: BoxConstraints(minWidth: 330),
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: DayEditorPanel(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
