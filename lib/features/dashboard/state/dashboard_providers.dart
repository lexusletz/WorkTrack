import 'package:flutter_riverpod/legacy.dart';
import '../../../core/forecast/forecast_providers.dart';

final browsedMonthProvider = StateProvider<DateTime>((ref) {
  final now = ref.read(nowProvider);
  return DateTime(now.year, now.month);
});

final selectedDayProvider = StateProvider<DateTime?>((_) => null);
