import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../preferences_model.dart';
import '../preferences_repository.dart';

const _BASE_URL = "http://localhost:8080/preferences";

class RemotePreferencesDataSource implements PreferencesRepository {
  final Logger logger = Logger('RemotePreferencesRepository');

  @override
  Future<Preferences> load() async {
    final url = Uri.parse(_BASE_URL);

    final response = await http.get(url);

    final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

    logger.info("PREFERENCES | loaded from server: $decodedResponse");

    return Preferences.fromJson(decodedResponse);
  }

  @override
  Future<void> save(Preferences prefs) async {
    final url = Uri.parse(_BASE_URL);

    logger.info("PREFERENCES | sending to the server: ${prefs.toJsonString()}");

    final response = await http.put(url, body: prefs.toJsonString());

    logger.info("PREFERENCES | response from server: ${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;

      logger.info("PREFERENCES | Preferences saved in the server: $decodedResponse");
    }
  }
}
