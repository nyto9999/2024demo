class ExistException implements Exception {
  final String message = 'Document already exists';
  ExistException();
}