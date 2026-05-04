import 'package:shared_preferences/shared_preferences.dart';

import 'paired_device.dart';

class PairedDevicesRepository {
  PairedDevicesRepository(this._prefs);

  static const _key = 'paired_devices_v1';
  final SharedPreferences _prefs;

  List<PairedDevice> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      return PairedDevice.listFromJson(raw);
    } catch (_) {
      return [];
    }
  }

  Future<void> save(PairedDevice device) async {
    final all = getAll();
    final idx = all.indexWhere((d) => d.id == device.id);
    if (idx >= 0) {
      all[idx] = device;
    } else {
      all.add(device);
    }
    await _prefs.setString(_key, PairedDevice.listToJson(all));
  }

  Future<void> remove(String deviceId) async {
    final all = getAll()..removeWhere((d) => d.id == deviceId);
    await _prefs.setString(_key, PairedDevice.listToJson(all));
  }

  Future<void> updateLastSync(String deviceId) async {
    final all = getAll();
    final idx = all.indexWhere((d) => d.id == deviceId);
    if (idx < 0) return;
    all[idx] = all[idx].copyWith(lastSyncAt: DateTime.now());
    await _prefs.setString(_key, PairedDevice.listToJson(all));
  }

  bool isPaired(String deviceId) => getAll().any((d) => d.id == deviceId);
}
