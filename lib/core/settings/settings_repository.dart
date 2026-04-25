import 'package:shared_preferences/shared_preferences.dart';
import 'settings_model.dart';

class SettingsRepository {
  SettingsRepository(this._prefs);

  static const _key = 'settings.v1';
  final SharedPreferences _prefs;

  Future<Settings> load() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return Settings.defaults;

    return Settings.fromJsonString(raw);
  }

  Future<void> save(Settings s) => _prefs.setString(_key, s.toJsonString());
}
