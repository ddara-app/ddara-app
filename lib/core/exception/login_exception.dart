sealed class AppException implements Exception {}

class UnauthorizedException extends AppException {}

class NetworkException extends AppException {}
