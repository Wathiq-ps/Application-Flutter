import 'package:mobile/core/cache/data_result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../data_sources/profile_remote_data_source.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._dataSource);

  final ProfileRemoteDataSource _dataSource;

  @override
  Stream<DataResult<ProfileEntity>> watchProfile() async* {
    final raw = await _dataSource.getProfileJson();
    yield DataResult<ProfileEntity>(
      data: ProfileModel.fromJson(raw),
      isFromCache: false,
      updatedAt: DateTime.now(),
    );
  }
}