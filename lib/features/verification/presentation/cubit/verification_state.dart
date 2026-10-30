import 'package:image_picker/image_picker.dart';

import '../../data/models/verification_model.dart';

enum RequestStatus { initial, loading, success, failure }

class VerificationState {
  final RequestStatus status;
  final VerificationModel? verification;
  final String? errorMessage;
  final XFile? idImage;
  final XFile? selfieImage;

  const VerificationState({
    this.status = RequestStatus.initial,
    this.verification,
    this.errorMessage,
    this.idImage,
    this.selfieImage,
  });

  bool get isLoading => status == RequestStatus.loading;

  VerificationState copyWith({
    RequestStatus? status,
    VerificationModel? verification,
    String? errorMessage,
    XFile? idImage,
    XFile? selfieImage,
    bool clearError = false,
  }) {
    return VerificationState(
      status: status ?? this.status,
      verification: verification ?? this.verification,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      idImage: idImage ?? this.idImage,
      selfieImage: selfieImage ?? this.selfieImage,
    );
  }
}