class ApiException implements Exception {
  final String? message;
  final int code;

  ApiException(this.code, this.message);

  @override
  String toString() {
    if (message == null) return "Exception";
    return "ApiException:($code) $message";
  }
}