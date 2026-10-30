import '../../domain/entities/edit_profile_user_entity.dart';
import '../../domain/repository/edit_profile_repository.dart';
import '../data_sources/edit_profile_remote_data_source.dart';
import '../models/edit_profile_user_model.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  const EditProfileRepositoryImpl(this._dataSource);

  final EditProfileRemoteDataSource _dataSource;

  @override
  Future<EditProfileUserEntity> getProfile() async {
    final raw = await _dataSource.getProfileRaw();
    return EditProfileUserModel.fromJson(raw['user'] as Map<String, dynamic>);
  }

  @override
  Future<EditProfileUserEntity> updateProfile({
    required String name,
    required String nationality,
    required ProfileDocumentType documentType,
    required String documentNumber,
    SignatureInput? signature,
  }) async {
    final raw = await _dataSource.updateProfileRaw(
      {
        '_method': 'PATCH',
        'name': name,
        'nationality': nationality,
        'document_type': documentType.apiValue,
        'document_number': documentNumber, // see note #2 above if this key is wrong
      },
      signature,
    );
    return EditProfileUserModel.fromJson(raw['user'] as Map<String, dynamic>);
  }
}