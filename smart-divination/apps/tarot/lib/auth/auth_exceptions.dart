class AuthRequiredException implements Exception {
  const AuthRequiredException([this.message = 'Authentication required.']);

  final String message;

  @override
  String toString() => 'AuthRequiredException: $message';
}
