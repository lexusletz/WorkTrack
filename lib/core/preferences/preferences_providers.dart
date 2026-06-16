import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_sources/local_preferences_data_source.dart';
import 'preferences_model.dart';
import 'preferences_orchestrator.dart';
import 'data_sources/remote_preferences_data_source.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

final localPreferencesRepositoryProvider = Provider<LocalPreferencesDataSource>(
  (ref) {
    final prefs = ref.watch(sharedPrefsProvider);

    return LocalPreferencesDataSource(prefs);
  },
);

final remotePreferencesRepositoryProvider =
    Provider<RemotePreferencesDataSource>((ref) {
      return RemotePreferencesDataSource();
    });

final preferencesOrchestratorProvider = Provider<PreferencesOrchestrator>((
  ref,
) {
  final local = ref.watch(localPreferencesRepositoryProvider);
  final remote = ref.watch(remotePreferencesRepositoryProvider);

  return PreferencesOrchestrator(local, remote);
});

class PreferencesNotifier extends AsyncNotifier<Preferences> {
  @override
  Future<Preferences> build() =>
      ref.read(preferencesOrchestratorProvider).load();

  Future<void> savePreferences(Preferences next) async {
    state = AsyncData(next);
    await ref.read(preferencesOrchestratorProvider).save(next);
  }
}

final preferencesProvider =
    AsyncNotifierProvider<PreferencesNotifier, Preferences>(
      PreferencesNotifier.new,
    );
