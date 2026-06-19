import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import '../../../utils/exceptions.dart';
import '../../domain/preferences_model.dart';

const _BASE_URL = "http://localhost:8080/preferences";

class RemotePreferencesDataSource {
  final Logger logger = Logger('RemotePreferencesRepository');

  Future<Preferences> load() async {
    try {
      final url = Uri.parse(_BASE_URL);

      logger.info("PREFERENCES | gettings preferences from server");

      final response = await http.get(url);

      logger.info("PREFERENCES | response from server status: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        logger.info("PREFERENCES | loaded from server: $decodedResponse");
        return Preferences.fromJson(decodedResponse);
      }

      logger.severe("PREFERENCES | Server error status: ${response.statusCode} body: ${response.body}");
      throw NetworkException("Status code ${response.statusCode}: ${response.body}");

    } on http.ClientException catch (e) {
      logger.severe("PREFERENCES | HTTP Client Error: $e");
      throw NetworkException("No internet connection or server unreachable");
    } on FormatException catch (e) {
      logger.severe("PREFERENCES | JSON Parsing Error: $e");
      throw NetworkException("Invalid response format from server");
    } catch (e) {
      logger.severe("PREFERENCES | Unexpected error: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Unknown error: $e");
    }
  }

  Future<void> save(Preferences prefs) async {
    try {
      final url = Uri.parse(_BASE_URL);

      logger.info("PREFERENCES | sending to the server: ${prefs.toJsonString()}");

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: prefs.toJsonString(),
      );

      logger.info("PREFERENCES | response from server status: ${response.statusCode}");

      if (response.statusCode >= 200 && response.statusCode <= 300) {
        final decodedResponse = jsonDecode(response.body) as Map<String, dynamic>;
        logger.info("PREFERENCES | Preferences saved in the server: $decodedResponse");
        return;
      }

      logger.severe("PREFERENCES | Server error status: ${response.statusCode} body: ${response.body}");
      throw NetworkException("Status code ${response.statusCode}: ${response.body}");

    } on http.ClientException catch (e) {
      logger.severe("PREFERENCES | HTTP Client Error: $e");
      throw NetworkException("No internet connection or server unreachable");
    } on FormatException catch (e) {
      logger.severe("PREFERENCES | JSON Parsing Error: $e");
      throw NetworkException("Invalid response format from server");
    } catch (e) {
      logger.severe("PREFERENCES | Unexpected error: $e");
      if (e is NetworkException) rethrow;
      throw NetworkException("Unknown error: $e");
    }
  }
}
