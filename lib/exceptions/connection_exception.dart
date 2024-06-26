/// When we can't connect to the printer
class ConnectionException implements Exception {
  final String message;

  ConnectionException(this.message);
}
