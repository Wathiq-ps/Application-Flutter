import 'package:equatable/equatable.dart';

enum ResourceStatus { initial, loading, success, failure }

class ResourceState<T> extends Equatable {
  final ResourceStatus status;
  final T? data;
  final bool isFromCache;
  final bool isRefreshing;
  final DateTime? updatedAt;
  final String? errorMessage;   

  const ResourceState({
    this.status = ResourceStatus.initial,
    this.data,
    this.isFromCache = false,
    this.isRefreshing = false,
    this.updatedAt,
    this.errorMessage,
  });

  bool get hasData => data != null;
  bool get isInitialLoading => !hasData && status != ResourceStatus.failure;
  bool get isInitialFailure => !hasData && status == ResourceStatus.failure;
  bool get isShowingStaleData => hasData && errorMessage != null;

  ResourceState<T> copyWith({
    ResourceStatus? status,
    T? data,
    bool? isFromCache,
    bool? isRefreshing,
    DateTime? updatedAt,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ResourceState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      isFromCache: isFromCache ?? this.isFromCache,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      updatedAt: updatedAt ?? this.updatedAt,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [status, data, isFromCache, isRefreshing, updatedAt, errorMessage];
}