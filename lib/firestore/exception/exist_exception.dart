class ExistException implements Exception {
  final String message = 'Document already exists';
  ExistException();
}


class UnauthorizedException implements Exception {
  final String message;
  UnauthorizedException(this.message);
}
