import 'package:equatable/equatable.dart';
import '../../domain/entities/edit_profile_user_entity.dart';
import '../../domain/repository/edit_profile_repository.dart';

enum EditProfileStatus { initial, loading, loadFailed, ready, saving, saveFailed, saved }

class EditProfileState extends Equatable {
  const EditProfileState({
    this.status = EditProfileStatus.initial,
    this.name = '',
    this.nationality = '',
    this.documentType = ProfileDocumentType.id,
    this.documentNumber = '',
    this.email = '',
    this.phone,
    this.dateOfBirth,
    this.hasExistingSignature = false,
    this.pendingSignature,
    this.localAvatarPath,
    this.errorMessage,
    this.fieldErrors = const {},
  });

  final EditProfileStatus status;
  final String name;
  final String nationality;
  final ProfileDocumentType documentType;
  final String documentNumber;
  final String email;
  final String? phone;
  final DateTime? dateOfBirth;
  final bool hasExistingSignature;
  final SignatureInput? pendingSignature;
  final String? localAvatarPath;
  final String? errorMessage;
  final Map<String, List<String>> fieldErrors;

  bool get isLoading => status == EditProfileStatus.loading;
  bool get isLoadFailed => status == EditProfileStatus.loadFailed;
  bool get isSaving => status == EditProfileStatus.saving;
  bool get hasSignatureToShow => pendingSignature != null || hasExistingSignature;

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? name,
    String? nationality,
    ProfileDocumentType? documentType,
    String? documentNumber,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    bool? hasExistingSignature,
    SignatureInput? pendingSignature,
    bool clearPendingSignature = false,
    String? localAvatarPath,
    String? errorMessage,
    Map<String, List<String>>? fieldErrors,
    bool clearError = false,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      nationality: nationality ?? this.nationality,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      hasExistingSignature: hasExistingSignature ?? this.hasExistingSignature,
      pendingSignature: clearPendingSignature ? null : (pendingSignature ?? this.pendingSignature),
      localAvatarPath: localAvatarPath ?? this.localAvatarPath,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      fieldErrors: clearError ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    nationality,
    documentType,
    documentNumber,
    email,
    phone,
    dateOfBirth,
    hasExistingSignature,
    pendingSignature,
    localAvatarPath,
    errorMessage,
    fieldErrors,
  ];
}