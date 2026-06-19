import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../utils/exceptions.dart';
import '../../utils/result.dart';
import '../domain/preferences_model.dart';
import '../domain/preferences_repository_interface.dart';
import 'data_sources/local_preferences_data_source.dart';
import 'data_sources/remote_preferences_data_source.dart';

class PreferencesRepositoryImpl implements PreferencesRepositoryInterface {
  final RemotePreferencesDataSource _remoteDataSource;
  final LocalPreferencesDataSource _localDataSource;

  const PreferencesRepositoryImpl(
    this._remoteDataSource, 
    this._localDataSource
  );

  // Load
  //   a. If there is no connection, it should load the local preferences.
  //   b. If there is no local preferences, it should use the default ones.
  //   c. If there is connection, it should load the preferences from the
  //      server and save them locally.
  @override
  Future<Result<Preferences>> load() async {
    try {
      if (!await InternetConnectionChecker.instance.hasConnection) {
        return Result.ok(await _localDataSource.load());
      } else {
        final remotePrefs = await _remoteDataSource.load();

        await _localDataSource.save(remotePrefs);

        return Result.ok(remotePrefs);
      }
    } on NetworkException catch (e) {
      return Result.error(e);
    }
  }

  // Local First Strategy
  //
  // INFO: We could add that locally we save if the preferences were saved on the
  // server correctly, if not, we could retry when the user opens the app again
  // or when know there is connection.
  @override
  Future<Result<void>> save(Preferences prefs) async {
    try {
      await _localDataSource.save(prefs);
      await _remoteDataSource.save(prefs);
      return Ok(null);
    } on NetworkException catch (e) {
      return Error(e);
    }
  }
}
