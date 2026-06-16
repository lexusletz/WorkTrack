import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../preferences_model.dart';
import '../preferences_repository.dart';

class LocalPreferencesDataSource implements PreferencesRepository {
  final Logger logger = Logger('LocalPreferencesRepository');

  final SharedPreferences _prefs;

  static const _key = 'settings.v1';

  LocalPreferencesDataSource(this._prefs);

  @override
  Future<Preferences> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return Preferences.defaults;

    return Preferences.fromJsonString(raw);
  }

  @override
  Future<void> save(Preferences prefs) async {
    _prefs.setString(_key, prefs.toJsonString());
  }
}
