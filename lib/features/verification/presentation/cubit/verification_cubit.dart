import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/error/verification_exception.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../domain/repositories/verify_repositories.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepository _repository;
  final ImagePickerService _imagePicker;

  VerificationCubit(this._repository, this._imagePicker)
      : super(const VerificationState());

  // ─────────────────────────────────────────
  // Picking
  // ─────────────────────────────────────────

  Future<void> pickIdImage({required bool fromCamera}) async {
    final image = await _pick(fromCamera: fromCamera, frontCamera: false);
    if (image == null) return;
    emit(state.copyWith(
      idImage: image,
      status: RequestStatus.initial,
      clearError: true,
    ));
  }

  Future<void> pickSelfieImage({required bool fromCamera}) async {
    final image = await _pick(fromCamera: fromCamera, frontCamera: true);
    if (image == null) return;
    emit(state.copyWith(
      selfieImage: image,
      status: RequestStatus.initial,
      clearError: true,
    ));
  }

  Future<XFile?> _pick({
    required bool fromCamera,
    required bool frontCamera,
  }) async {
    try {
      String? path;
      if (fromCamera) {
        path = await _imagePicker.takePhoto(useFrontCamera: frontCamera);
      } else {
        final paths = await _imagePicker.pickImages(limit: 1);
        path = paths.isEmpty ? null : paths.first;
      }
      return path == null ? null : XFile(path);
    } catch (_) {
      _emitFailure(AppStrings.imagePickFailed);
      return null;
    }
  }

  // ─────────────────────────────────────────
  // Submit
  // ─────────────────────────────────────────

  Future<void> submitVerification() async {
    final idImage = state.idImage;
    final selfieImage = state.selfieImage;

    if (idImage == null) {
      _emitFailure(AppStrings.pleaseUploadIdFirst);
      return;
    }
    if (selfieImage == null) {
      _emitFailure(AppStrings.pleaseTakeSelfieFirst);
      return;
    }

    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      final verification = await _repository.uploadIdAndSelfie(
        idImage: idImage,
        selfieImage: selfieImage,
      );
      emit(state.copyWith(
        status: RequestStatus.success,
        verification: verification,
        clearError: true,
      ));
    } on VerificationException catch (e) {
      _emitFailure(e.message);
    } catch (_) {
      _emitFailure(AppStrings.somethingWentWrong);
    }
  }

  Future<void> getVerificationStatus() async {
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));

    try {
      final verification = await _repository.getVerificationStatus();
      emit(state.copyWith(
        status: RequestStatus.success,
        verification: verification,
        clearError: true,
      ));
    } on VerificationException catch (e) {
      _emitFailure(e.message);
    } catch (_) {
      _emitFailure(AppStrings.somethingWentWrong);
    }
  }

  void reset() => emit(const VerificationState());

  /// Goes through `initial` first so the failure is always a status change and
  /// the snackbar listener fires even for two identical errors in a row.
  void _emitFailure(String message) {
    emit(state.copyWith(status: RequestStatus.initial, clearError: true));
    emit(state.copyWith(status: RequestStatus.failure, errorMessage: message));
  }
}