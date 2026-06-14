import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'preferences_model.dart';
import 'preferences_repository.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);

  return PreferencesRepository(prefs);
});

class PreferencesNotifier extends AsyncNotifier<Preferences> {
  @override
  Future<Preferences> build() =>
      ref.read(preferencesRepositoryProvider).loadPreferences();

  Future<void> savePreferences(Preferences next) async {
    state = AsyncData(next);
    await ref.read(preferencesRepositoryProvider).save(next);
  }
}

final preferencesProvider = AsyncNotifierProvider<PreferencesNotifier, Preferences>(
  PreferencesNotifier.new,
);
