import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/preferences_model.dart';

class LocalPreferencesDataSource {
  final Logger logger = Logger('LocalPreferencesRepository');

  final SharedPreferences _prefs;

  static const _key = 'settings.v1';

  LocalPreferencesDataSource(this._prefs);

  Future<Preferences> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return Preferences.defaults;

    return Preferences.fromJsonString(raw);
  }

  Future<void> save(Preferences prefs) async {
    await _prefs.setString(_key, prefs.toJsonString());
  }
}
