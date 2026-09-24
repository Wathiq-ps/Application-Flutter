class DataResult<T> {
  final T data;
  final bool isFromCache;
  final DateTime? updatedAt;
  final Object? refreshError;

  const DataResult({
    required this.data,
    required this.isFromCache,
    this.updatedAt,
    this.refreshError,
  });
}