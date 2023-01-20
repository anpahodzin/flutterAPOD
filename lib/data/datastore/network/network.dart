import 'package:http/http.dart' as http;

class Network {
  final http.Client client;

  Network({required this.client});
}

class ApiException implements Exception {
  final String? message;
  final int code;

  ApiException(this.code, this.message);

  String toString() {
    if (message == null) return "Exception";
    return "ApiException:($code) $message";
  }
}
