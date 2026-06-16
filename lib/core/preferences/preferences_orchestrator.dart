import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'data_sources/local_preferences_data_source.dart';
import 'preferences_model.dart';
import 'data_sources/remote_preferences_data_source.dart';

class PreferencesOrchestrator {
  final LocalPreferencesDataSource _localPreferences;
  final RemotePreferencesDataSource _remotePreferences;

  const PreferencesOrchestrator(
    this._localPreferences,
    this._remotePreferences,
  );

  Future<Preferences> load() async {
    if (!await InternetConnectionChecker.instance.hasConnection) {
      return _localPreferences.load();
    } else {
      final prefs = await _remotePreferences.load();

      _localPreferences.save(prefs);

      return prefs;
    }
  }

  Future<void> save(Preferences prefs) async {
    _localPreferences.save(prefs);
    _remotePreferences.save(prefs);
  }
}
