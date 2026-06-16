import 'preferences_model.dart';

abstract class PreferencesRepository {
  Future<void> save(Preferences prefs);
  Future<Preferences> load();
}
