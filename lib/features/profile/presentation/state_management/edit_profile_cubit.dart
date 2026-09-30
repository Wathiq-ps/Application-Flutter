import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/error/api_exception.dart';
import '../../../../core/constant/strings.dart';
import '../../data/error/profile_validation_exception.dart';
import '../../domain/entities/edit_profile_user_entity.dart';
import '../../domain/repository/edit_profile_repository.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._repository) : super(const EditProfileState());

  final EditProfileRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(status: EditProfileStatus.loading, clearError: true));
    try {
      final profile = await _repository.getProfile();
      emit(state.copyWith(
        status: EditProfileStatus.ready,
        name: profile.name,
        nationality: profile.nationality ?? '',
        documentType: profile.documentType,
        documentNumber: profile.documentNumber ?? '',
        email: profile.email,
        phone: profile.phone,
        dateOfBirth: profile.dateOfBirth,
        hasExistingSignature: profile.hasSignature,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(status: EditProfileStatus.loadFailed, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: EditProfileStatus.loadFailed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  void setName(String v) => emit(state.copyWith(name: v));
  void setNationality(String v) => emit(state.copyWith(nationality: v));
  void setDocumentType(ProfileDocumentType v) => emit(state.copyWith(documentType: v));
  void setDocumentNumber(String v) => emit(state.copyWith(documentNumber: v));
  void setPhone(String v) => emit(state.copyWith(phone: v)); // UI only for now
  void setDateOfBirth(DateTime v) => emit(state.copyWith(dateOfBirth: v)); // UI only for now
  void setLocalAvatarPath(String path) => emit(state.copyWith(localAvatarPath: path)); // UI only

  void setUploadedSignature(String filePath) {
    emit(state.copyWith(pendingSignature: SignatureInput.file(filePath)));
  }

  /// Takes the PNG bytes captured straight from the drawing canvas.
  void setDrawnSignature(Uint8List pngBytes) {
    emit(state.copyWith(pendingSignature: SignatureInput.bytes(pngBytes)));
  }

  void clearSignature() {
    emit(state.copyWith(clearPendingSignature: true, hasExistingSignature: false));
  }

  Future<bool> save() async {
    emit(state.copyWith(status: EditProfileStatus.saving, clearError: true));
    try {
      await _repository.updateProfile(
        name: state.name,
        nationality: state.nationality,
        documentType: state.documentType,
        documentNumber: state.documentNumber,
        signature: state.pendingSignature,
      );
      emit(state.copyWith(status: EditProfileStatus.saved, clearPendingSignature: true));
      return true;
    } on ProfileValidationException catch (e) {
      emit(state.copyWith(
        status: EditProfileStatus.saveFailed,
        errorMessage: e.message,
        fieldErrors: e.fieldErrors,
      ));
      return false;
    } on ApiException catch (e) {
      emit(state.copyWith(status: EditProfileStatus.saveFailed, errorMessage: e.message));
      return false;
    } catch (_) {
      emit(state.copyWith(
        status: EditProfileStatus.saveFailed,
        errorMessage: AppStrings.somethingWentWrong,
      ));
      return false;
    }
  }
}