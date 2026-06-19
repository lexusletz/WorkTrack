import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/result.dart';
import '../data/data_sources/local_preferences_data_source.dart';
import '../data/data_sources/remote_preferences_data_source.dart';
import '../data/preferences_repository.dart';
import '../domain/preferences_model.dart';
import '../domain/preferences_repository_interface.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError();
});

final localPreferencesRepositoryProvider = Provider<LocalPreferencesDataSource>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);

  return LocalPreferencesDataSource(prefs);
});

final remotePreferencesRepositoryProvider = Provider<RemotePreferencesDataSource>((ref) {
  return RemotePreferencesDataSource();
});

final preferencesRepositoryProvider = Provider<PreferencesRepositoryInterface>((ref) {
  final local = ref.watch(localPreferencesRepositoryProvider);
  final remote = ref.watch(remotePreferencesRepositoryProvider);

  return PreferencesRepositoryImpl(remote, local);
});

class PreferencesNotifier extends AsyncNotifier<Preferences> {
  @override
  Future<Preferences> build() async {
      final prefsResult = await ref.watch(preferencesRepositoryProvider).load();

      switch (prefsResult) {
        case Ok<Preferences>():
          return prefsResult.value;
        case Error<Preferences>():
          return Preferences.defaults;
      }
  }

  Future<void> savePreferences(Preferences next) async {
    state = await AsyncValue.guard(() async {
      await ref.read(preferencesRepositoryProvider).save(next);
      return next;
    });
  }
}

final preferencesProvider = AsyncNotifierProvider<PreferencesNotifier, Preferences>(
  PreferencesNotifier.new,
);
