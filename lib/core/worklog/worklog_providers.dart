import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'worklog_model.dart';
import 'worklog_repository.dart';

final worklogBoxProvider = Provider<Box<WorkLog>>(
  (_) => throw UnimplementedError('worklogBoxProvider not overridden'),
);

final worklogRepositoryProvider = Provider<WorkLogRepository>(
  (ref) => WorkLogRepository(ref.watch(worklogBoxProvider)),
);

final worklogsForMonthProvider = StreamProvider.family<List<WorkLog>, DateTime>(
  (ref, month) {
    final repo = ref.watch(worklogRepositoryProvider);

    final controller = StreamController<List<WorkLog>>();

    controller.add(repo.forMonth(month));
    final sub = repo.watch().listen(
      (_) => controller.add(repo.forMonth(month)),
    );

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
