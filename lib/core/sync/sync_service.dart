import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../worklog/worklog_model.dart';
import '../worklog/worklog_repository.dart';

class SyncService {
  SyncService({
    required WorkLogRepository worklogRepo,
    required SharedPreferences prefs,
  })  : _worklogRepo = worklogRepo,
        _prefs = prefs;

  static final _log = Logger('SyncService');
  static const _timestampsKey = 'sync_worklog_timestamps_v1';

  final WorkLogRepository _worklogRepo;
  final SharedPreferences _prefs;

  bool _isSyncing = false;
  StreamSubscription<BoxEvent>? _boxSub;

  void Function()? onSyncComplete;

  Future<void> initialize() async {
    _boxSub = _worklogRepo.watch().listen((event) {
      if (!_isSyncing && event.key is String && !event.deleted) {
        _markModified(event.key as String);
      }
    });
  }

  void _markModified(String key) {
    final ts = _loadTimestamps();
    ts[key] = DateTime.now().millisecondsSinceEpoch;
    _prefs.setString(_timestampsKey, jsonEncode(ts));
  }

  Map<String, int> _loadTimestamps() {
    final raw = _prefs.getString(_timestampsKey);
    if (raw == null) return {};
    try {
      return Map<String, int>.from(jsonDecode(raw) as Map);
    } catch (_) {
      return {};
    }
  }

  Uint8List buildPayload(String senderDeviceId) {
    final timestamps = _loadTimestamps();
    final logs = _worklogRepo.getAll();

    final entries = logs.map((log) => {
      'key': log.key,
      'date': log.date.millisecondsSinceEpoch,
      'hoursWorked': log.hoursWorked,
      'isExtraDay': log.isExtraDay,
      'notes': log.notes,
      'updatedAt': timestamps[log.key] ?? 0,
    }).toList();

    return Uint8List.fromList(
      utf8.encode(
        jsonEncode({
          'deviceId': senderDeviceId,
          'sentAt': DateTime.now().millisecondsSinceEpoch,
          'worklogs': entries,
        }),
      ),
    );
  }

  Future<void> processReceived(Uint8List bytes) async {
    try {
      final json = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
      final worklogs = json['worklogs'] as List<dynamic>;

      _isSyncing = true;
      final timestamps = _loadTimestamps();
      var mergedCount = 0;

      for (final entry in worklogs) {
        final map = entry as Map<String, dynamic>;
        final key = map['key'] as String;
        final remoteUpdatedAt = map['updatedAt'] as int;
        final localUpdatedAt = timestamps[key] ?? 0;

        if (remoteUpdatedAt >= localUpdatedAt) {
          await _worklogRepo.put(WorkLog(
            date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
            hoursWorked: (map['hoursWorked'] as num).toDouble(),
            isExtraDay: map['isExtraDay'] as bool,
            notes: map['notes'] as String?,
          ));
          timestamps[key] = remoteUpdatedAt;
          mergedCount++;
        }
      }

      await _prefs.setString(_timestampsKey, jsonEncode(timestamps));
      _log.info('Sync: merged $mergedCount / ${worklogs.length} records');
      onSyncComplete?.call();
    } catch (e) {
      _log.warning('processReceived error: $e');
    } finally {
      _isSyncing = false;
    }
  }

  void dispose() {
    _boxSub?.cancel();
  }
}
