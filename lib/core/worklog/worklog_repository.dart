import 'package:hive/hive.dart';
import 'worklog_model.dart';

class WorkLogRepository {
  WorkLogRepository(this._box);

  final Box<WorkLog> _box;

  WorkLog? get(DateTime d) => _box.get(WorkLog.keyFor(d));

  Future<void> put(WorkLog log) => _box.put(log.key, log);

  Future<void> delete(DateTime d) => _box.delete(WorkLog.keyFor(d));

  List<WorkLog> forMonth(DateTime month) {
    final prefix = '${month.year.toString().padLeft(4, '0')}-'
        '${month.month.toString().padLeft(2, '0')}-';
    return _box.values.where((l) => l.key.startsWith(prefix)).toList();
  }

  Stream<BoxEvent> watch() => _box.watch();
}
