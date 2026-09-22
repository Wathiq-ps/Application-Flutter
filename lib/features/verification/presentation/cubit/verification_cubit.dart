import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/repositories/verify_repositories.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepository repository;

  VerificationCubit(this.repository) : super(const VerificationState());

  XFile? _idImage;
  XFile? _selfieImage;

  XFile? get idImage => _idImage;
  XFile? get selfieImage => _selfieImage;

  void setIdImage(XFile image) {
    _idImage = image;
    emit(state.copyWith(status: RequestStatus.initial, clearError: true));
  }

  void setSelfieImage(XFile image) {
    _selfieImage = image;
    emit(state.copyWith(status: RequestStatus.initial, clearError: true));
  }

  void removeIdImage() {
    _idImage = null;
    emit(state.copyWith(status: RequestStatus.initial, clearError: true));
  }

  void removeSelfieImage() {
    _selfieImage = null;
    emit(state.copyWith(status: RequestStatus.initial, clearError: true));
  }

  Future<void> submitVerification(
    String s, {
    required String documentNumber,
  }) async {
    if (_idImage == null) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: 'Please upload your ID first',
        ),
      );
      return;
    }

    if (_selfieImage == null) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: 'Please take a selfie first',
        ),
      );
      return;
    }

    if (documentNumber.trim().isEmpty) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: 'Please enter your document number',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      final verification = await repository.uploadIdAndSelfie(
        idImage: _idImage!,
        selfieImage: _selfieImage!,
        documentNumber: documentNumber.trim(),
      );

      emit(
        state.copyWith(
          status: RequestStatus.success,
          verification: verification,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: _mapError(e),
        ),
      );
    }
  }

  Future<void> getVerificationStatus() async {
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      final verification = await repository.getVerificationStatus();

      emit(
        state.copyWith(
          status: RequestStatus.success,
          verification: verification,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: _mapError(e),
        ),
      );
    }
  }

  void reset() {
    _idImage = null;
    _selfieImage = null;
    emit(const VerificationState());
  }

  String _mapError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'Check your internet connection and try again';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}
