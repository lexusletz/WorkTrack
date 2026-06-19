import '../../utils/result.dart';
import 'preferences_model.dart';

abstract class PreferencesRepositoryInterface {
  Future<Result<void>> save(Preferences prefs);
  Future<Result<Preferences>> load();
}
