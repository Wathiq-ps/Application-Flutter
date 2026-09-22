import '../../data/models/verification_model.dart';

enum RequestStatus { initial, loading, success, failure }

enum VerificationErrorType {
  noIdImage,
  noSelfieImage,
  network,
  server,
  unknown,
}

class VerificationState {
  final RequestStatus status;
  final VerificationModel? verification;
  final String? errorMessage;

  const VerificationState({
    this.status = RequestStatus.initial,
    this.verification,
    this.errorMessage,
  });

  VerificationState copyWith({
    RequestStatus? status,
    VerificationModel? verification,
    String? errorMessage,
    bool clearError = false,
  }) {
    return VerificationState(
      status: status ?? this.status,
      verification: verification ?? this.verification,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
