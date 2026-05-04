import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import 'device_discovery_service.dart';
import 'paired_device.dart';
import 'paired_devices_repository.dart';
import 'sync_service.dart';

class SyncOrchestrator {
  SyncOrchestrator({
    required DeviceDiscoveryService discovery,
    required PairedDevicesRepository pairedRepo,
    required SyncService syncService,
  })  : _discovery = discovery,
        _pairedRepo = pairedRepo,
        _syncService = syncService;

  static final _log = Logger('SyncOrchestrator');

  final DeviceDiscoveryService _discovery;
  final PairedDevicesRepository _pairedRepo;
  final SyncService _syncService;

  final nearbyDevices = ValueNotifier<List<NearbyDevice>>([]);
  final pairedDevices = ValueNotifier<List<PairedDevice>>([]);
  // Set of endpointIds currently sending a sync payload
  final syncingEndpoints = ValueNotifier<Set<String>>({});

  StreamSubscription<List<NearbyDevice>>? _discoverySub;

  Future<void> initialize() async {
    _log.info("Initializing SyncOrchestrator");
    await _discovery.initialize();
    await _syncService.initialize();

    _discovery.onConnectionEstablished = _onConnectionEstablished;
    _discovery.onPayloadReceived = _onPayloadReceived;
    _discovery.onDisconnected = _onDisconnected;

    pairedDevices.value = _pairedRepo.getAll();

    _discoverySub = _discovery.nearbyDevices.listen((devices) {
      nearbyDevices.value = devices;
      for (final device in devices) {
        if (_pairedRepo.isPaired(device.deviceId)) {
          _discovery.connectTo(device.endpointId);
        }
      }
    });

    await _discovery.startAll();
  }

  void _onConnectionEstablished(String endpointId, String deviceId) {
    _log.info('Connected: $deviceId ($endpointId)');
    if (_pairedRepo.isPaired(deviceId)) {
      _sendSyncPayload(endpointId);
    }
  }

  Future<void> _sendSyncPayload(String endpointId) async {
    syncingEndpoints.value = {...syncingEndpoints.value, endpointId};
    try {
      final payload = _syncService.buildPayload(_discovery.localDeviceId ?? '');
      await _discovery.sendBytes(endpointId, payload);
      _log.info('Sync payload sent to $endpointId');
    } finally {
      final updated = Set<String>.from(syncingEndpoints.value)..remove(endpointId);
      syncingEndpoints.value = updated;
    }
  }

  Future<void> _onPayloadReceived(
    String endpointId,
    String deviceId,
    Uint8List bytes,
  ) async {
    _log.info('Payload received from $deviceId');
    await _syncService.processReceived(bytes);
    if (_pairedRepo.isPaired(deviceId)) {
      await _pairedRepo.updateLastSync(deviceId);
      pairedDevices.value = _pairedRepo.getAll();
    }
  }

  void _onDisconnected(String endpointId) {
    final updated = Set<String>.from(syncingEndpoints.value)
      ..remove(endpointId);
    syncingEndpoints.value = updated;
  }

  // --- PUBLIC API ---

  Future<void> pairWithDevice(NearbyDevice device) async {
    final paired = PairedDevice(
      id: device.deviceId,
      name: device.displayName,
      pairedAt: DateTime.now(),
    );
    await _pairedRepo.save(paired);
    pairedDevices.value = _pairedRepo.getAll();
    await _discovery.connectTo(device.endpointId);
  }

  Future<void> unpairDevice(String deviceId) async {
    await _pairedRepo.remove(deviceId);
    pairedDevices.value = _pairedRepo.getAll();
    final target = nearbyDevices.value
        .where((d) => d.deviceId == deviceId)
        .firstOrNull;
    if (target != null) {
      await _discovery.disconnectFromEndpoint(target.endpointId);
    }
  }

  void dispose() {
    _discoverySub?.cancel();
    _discovery.dispose();
    _syncService.dispose();
    nearbyDevices.dispose();
    pairedDevices.dispose();
    syncingEndpoints.dispose();
  }
}
