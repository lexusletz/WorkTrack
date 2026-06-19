final class NetworkException implements Exception {
  NetworkException([String detail = ""])
    : message = "Error connecting to the server: ${detail.trim()}";

  final String message;
}
