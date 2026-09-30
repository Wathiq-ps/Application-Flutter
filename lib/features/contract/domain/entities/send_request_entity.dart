class SendRequestEntity {
  final String propertyId;
  final String? message;
  final String? termStart;
  final String? termEnd;

  const SendRequestEntity({
    required this.propertyId,
    this.message,
    this.termStart,
    this.termEnd,
  });
}
