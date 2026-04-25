import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_model.dart';
import 'settings_repository.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);

  return SettingsRepository(prefs);
});

class SettingsNotifier extends AsyncNotifier<Settings> {
  @override
  Future<Settings> build() => ref.read(settingsRepositoryProvider).load();

  Future<void> saveSettings(Settings next) async {
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, Settings>(
  SettingsNotifier.new,
);
