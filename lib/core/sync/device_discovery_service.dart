import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:location/location.dart';
import 'package:logging/logging.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';

const _serviceId = 'in.lexusletz.worktrack.sync';

class NearbyDevice {
  const NearbyDevice({
    required this.endpointId,
    required this.deviceId,
    required this.displayName,
  });

  final String endpointId;
  // Stable device ID of the remote device (used as its advertising nickname)
  final String deviceId;
  final String displayName;
}

class DeviceDiscoveryService {
  static final _log = Logger('DeviceDiscoveryService');

  final _nearby = Nearby();

  String? _localDeviceId;
  String? get localDeviceId => _localDeviceId;

  final _discovered = <String, NearbyDevice>{};
  final _activeEndpoints = <String>{};
  final _pendingConnections = <String>{};

  final _devicesController = StreamController<List<NearbyDevice>>.broadcast();
  Stream<List<NearbyDevice>> get nearbyDevices => _devicesController.stream;

  void Function(String endpointId, String deviceId)? onConnectionEstablished;
  void Function(String endpointId, String deviceId, Uint8List bytes)? onPayloadReceived;
  void Function(String endpointId)? onDisconnected;

  // --- INIT ---

  Future<void> initialize() async {
    if (Platform.isAndroid) {
      final info = await DeviceInfoPlugin().androidInfo;
      _localDeviceId = info.id;
    } else {
      _localDeviceId = 'desktop-${DateTime.now().millisecondsSinceEpoch}';
    }

    _log.info('Local device ID: $_localDeviceId');
  }

  // --- PERMISSIONS ---

  Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return true;

    if (!await Permission.location.isGranted) {
      if (!(await Permission.location.request()).isGranted) return false;
    }
    if (!await Permission.location.serviceStatus.isEnabled) {
      await Location.instance.requestService();
    }

    final btPerms = [
      Permission.bluetooth,
      Permission.bluetoothAdvertise,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ];
    for (final p in btPerms) {
      if (!await p.isGranted) await p.request();
    }

    await Permission.nearbyWifiDevices.request();

    return true;
  }

  // --- START / STOP ---

  Future<void> startAll() async {
    if (!Platform.isAndroid) {
      _log.info('P2P sync not supported on this platform');
      return;
    }

    await requestPermissions();
    await _startAdvertising();
    await _startDiscovery();
  }

  Future<void> stopAll() async {
    try {
      await _nearby.stopAdvertising();
      await _nearby.stopDiscovery();
      await _nearby.stopAllEndpoints();
    } catch (e) {
      _log.warning('Error stopping Nearby: $e');
    }

    _discovered.clear();
    _activeEndpoints.clear();
    _pendingConnections.clear();
    _devicesController.add([]);
  }

  Future<void> _startAdvertising() async {
    try {
      await _nearby.startAdvertising(
        _localDeviceId!,
        Strategy.P2P_CLUSTER,
        onConnectionInitiated: _onConnInitiated,
        onConnectionResult: _onConnResult,
        onDisconnected: _onEndpointDisconnected,
        serviceId: _serviceId,
      );
      _log.info('Advertising started');
    } catch (e) {
      _log.warning('Failed to start advertising: $e');
    }
  }

  Future<void> _startDiscovery() async {
    try {
      await _nearby.startDiscovery(
        _localDeviceId!,
        Strategy.P2P_CLUSTER,
        onEndpointFound: _onEndpointFound,
        onEndpointLost: _onEndpointLost,
        serviceId: _serviceId,
      );

      _log.info('Discovery started');
    } catch (e) {
      _log.warning('Failed to start discovery: $e');
    }
  }

  // --- NEARBY CALLBACKS ---

  void _onEndpointFound(
    String endpointId,
    String endpointName,
    String serviceId,
  ) {
    _log.info('Endpoint found: $endpointId ($endpointName)');
    _discovered[endpointId] = NearbyDevice(
      endpointId: endpointId,
      deviceId: endpointName,
      displayName: endpointName,
    );
    _devicesController.add(_discovered.values.toList());
  }

  void _onEndpointLost(String? endpointId) {
    if (endpointId == null) return;
    _log.info('Endpoint lost: $endpointId');
    _discovered.remove(endpointId);
    _activeEndpoints.remove(endpointId);
    _pendingConnections.remove(endpointId);
    _devicesController.add(_discovered.values.toList());
    onDisconnected?.call(endpointId);
  }

  void _onConnInitiated(String endpointId, ConnectionInfo info) {
    _log.info('Connection initiated: $endpointId (${info.endpointName})');

    // Ensure device is in discovered map (incoming connections may not be discovered yet)
    _discovered.putIfAbsent(
      endpointId,
      () => NearbyDevice(
        endpointId: endpointId,
        deviceId: info.endpointName,
        displayName: info.endpointName,
      ),
    );

    _nearby.acceptConnection(
      endpointId,
      onPayLoadRecieved: (endId, payload) {
        if (payload.type == PayloadType.BYTES && payload.bytes != null) {
          final device = _discovered[endId];
          final deviceId = device?.deviceId ?? info.endpointName;
          onPayloadReceived?.call(
            endId,
            deviceId,
            Uint8List.fromList(payload.bytes!),
          );
        }
      },
      onPayloadTransferUpdate: (id, update) {},
    );
  }

  void _onConnResult(String endpointId, Status status) {
    _log.info('Connection result: $endpointId -> $status');
    _pendingConnections.remove(endpointId);
    if (status == Status.CONNECTED && !_activeEndpoints.contains(endpointId)) {
      _activeEndpoints.add(endpointId);
      final device = _discovered[endpointId];
      if (device != null) {
        onConnectionEstablished?.call(endpointId, device.deviceId);
      }
    }
  }

  void _onEndpointDisconnected(String endpointId) {
    _log.info('Endpoint disconnected: $endpointId');
    _activeEndpoints.remove(endpointId);
    onDisconnected?.call(endpointId);
  }

  // --- PUBLIC METHODS ---

  Future<void> connectTo(String endpointId) async {
    if (_activeEndpoints.contains(endpointId) || _pendingConnections.contains(endpointId)) {
      return;
    }

    _pendingConnections.add(endpointId);

    try {
      await _nearby.requestConnection(
        _localDeviceId!,
        endpointId,
        onConnectionInitiated: _onConnInitiated,
        onConnectionResult: _onConnResult,
        onDisconnected: _onEndpointDisconnected,
      );
    } catch (e) {
      _pendingConnections.remove(endpointId);
      _log.warning('Failed to connect to $endpointId: $e');
    }
  }

  Future<void> sendBytes(String endpointId, Uint8List bytes) async {
    if (!_activeEndpoints.contains(endpointId)) return;

    try {
      await _nearby.sendBytesPayload(endpointId, bytes);
    } catch (e) {
      _log.warning('Failed to send bytes to $endpointId: $e');
    }
  }

  Future<void> disconnectFromEndpoint(String endpointId) async {
    try {
      await _nearby.disconnectFromEndpoint(endpointId);
    } catch (_) {}

    _activeEndpoints.remove(endpointId);
    _pendingConnections.remove(endpointId);
  }

  bool isConnected(String endpointId) => _activeEndpoints.contains(endpointId);

  NearbyDevice? getDevice(String endpointId) => _discovered[endpointId];

  void dispose() {
    stopAll();
    _devicesController.close();
  }
}
