class PostStatusException implements Exception {
  final String message;
  PostStatusException(this.message);

  @override
  String toString() => message;
}