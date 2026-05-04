import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/device_discovery_service.dart';
import '../../core/sync/paired_device.dart';
import '../../core/sync/sync_orchestrator.dart';
import '../../core/sync/sync_providers.dart';

class DevicesScreen extends ConsumerWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orchestrator = ref.watch(syncOrchestratorProvider);
    return _DevicesView(orchestrator: orchestrator);
  }
}

class _DevicesView extends StatelessWidget {
  const _DevicesView({required this.orchestrator});

  final SyncOrchestrator orchestrator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos'),
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PairedSection(orchestrator: orchestrator),
          const Divider(height: 1),
          Expanded(child: _NearbySection(orchestrator: orchestrator)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sección: Mis dispositivos (emparejados)
// ---------------------------------------------------------------------------

class _PairedSection extends StatelessWidget {
  const _PairedSection({required this.orchestrator});

  final SyncOrchestrator orchestrator;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        orchestrator.pairedDevices,
        orchestrator.nearbyDevices,
        orchestrator.syncingEndpoints,
      ]),
      builder: (context, _) {
        final paired = orchestrator.pairedDevices.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Mis dispositivos',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            if (paired.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Ningún dispositivo vinculado aún.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: paired.length,
                itemBuilder: (context, index) => _PairedTile(
                  device: paired[index],
                  orchestrator: orchestrator,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PairedTile extends StatelessWidget {
  const _PairedTile({required this.device, required this.orchestrator});

  final PairedDevice device;
  final SyncOrchestrator orchestrator;

  @override
  Widget build(BuildContext context) {
    final nearby = orchestrator.nearbyDevices.value;
    final syncing = orchestrator.syncingEndpoints.value;

    final nearbyDevice = nearby.where((d) => d.deviceId == device.id).firstOrNull;
    final isNearby = nearbyDevice != null;
    final isSyncing = isNearby && syncing.contains(nearbyDevice.endpointId);

    final statusText = isNearby
        ? (isSyncing ? 'Sincronizando...' : 'Cerca · Sincronizado')
        : 'No disponible';
    final statusColor = isNearby ? Colors.green : Colors.grey;

    return ListTile(
      leading: Icon(Icons.smartphone, color: statusColor),
      title: Text(device.name),
      subtitle: Text(
        statusText,
        style: TextStyle(color: statusColor, fontSize: 12),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.link_off),
        tooltip: 'Desvincular',
        onPressed: () => orchestrator.unpairDevice(device.id),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sección: Dispositivos cercanos (no emparejados)
// ---------------------------------------------------------------------------

class _NearbySection extends StatelessWidget {
  const _NearbySection({required this.orchestrator});

  final SyncOrchestrator orchestrator;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        orchestrator.nearbyDevices,
        orchestrator.pairedDevices,
      ]),
      builder: (context, _) {
        final pairedIds = orchestrator.pairedDevices.value.map((d) => d.id).toSet();
        final unpaired = orchestrator.nearbyDevices.value
            .where((d) => !pairedIds.contains(d.deviceId))
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Dispositivos cercanos',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
              ),
            ),
            if (unpaired.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Buscando dispositivos cercanos...',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: unpaired.length,
                  itemBuilder: (context, index) =>
                      _NearbyTile(device: unpaired[index], orchestrator: orchestrator),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _NearbyTile extends StatelessWidget {
  const _NearbyTile({required this.device, required this.orchestrator});

  final NearbyDevice device;
  final SyncOrchestrator orchestrator;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.smartphone_outlined),
      title: Text(device.displayName),
      subtitle: Text(
        device.deviceId,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 11),
      ),
      trailing: FilledButton(
        onPressed: () => orchestrator.pairWithDevice(device),
        child: const Text('Vincular'),
      ),
    );
  }
}
