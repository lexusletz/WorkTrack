import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preferences_model.dart';

// 1. We need to load the saved settings from the server.
// 2. There'll be always a settings object saved on the server,
// but the devices has to save it locally in case the user is offline.
// 3. If the user changes the settings on the device, the changes
// must be synced with the server.

class PreferencesRepository {
  final Logger logger = Logger('PreferencesRepository');

  final SharedPreferences _prefs;

  static const _key = 'settings.v1';

  PreferencesRepository(this._prefs);

  Future<Preferences> _loadFromLocal() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return Preferences.defaults;

    return Preferences.fromJsonString(raw);
  }

  // TODO: If it loads the Preferences from the server it has to update
  // the local preferences with the ones in the server
  Future<Preferences> _loadFromServer() async {
    final url = Uri.parse("http://localhost:8080/preferences");

    // NOTE: Add handling for the status code returned by the server
    // and validate errors
    final response = await http.get(url);

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

    logger.info("Preferences loaded from server: $decodedResponse");

    return Preferences.fromJson(decodedResponse);
  }

  Future<Preferences> loadPreferences() async {
    if (!await InternetConnectionChecker.instance.hasConnection) {
      return _loadFromLocal();
    }

    return _loadFromServer();
  }

  Future<void> _savePreferencesInServer(Preferences preferences) async {
    final url = Uri.parse("http://localhost:8080/preferences");

    logger.info("sending to the server: ${preferences.toJsonString()}");

    // NOTE: Add handling for the status code returned by the server
    // and validate errors
    final response = await http.put(url, body: preferences.toJsonString());

    logger.info("response from server: ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      logger.info("Preferences saved in the server: $decodedResponse");
    }
  }

  Future<void> save(Preferences s) async {
    _savePreferencesInServer(s);

    _prefs.setString(_key, s.toJsonString());
  }
}
