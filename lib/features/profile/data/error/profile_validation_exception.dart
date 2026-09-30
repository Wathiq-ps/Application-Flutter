class ProfileValidationException implements Exception {
  const ProfileValidationException(this.message, this.fieldErrors);

  final String message;
  final Map<String, List<String>> fieldErrors;

  String? errorFor(String field) => fieldErrors[field]?.first;

  @override
  String toString() => message;
}