class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.isNetwork = false});

  final String message;
  final int? statusCode;
  final bool isNetwork;

  @override
  String toString() => message;
}
