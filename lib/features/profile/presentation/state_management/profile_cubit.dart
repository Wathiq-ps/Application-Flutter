import 'package:mobile/core/cache/data_result.dart';
import 'package:mobile/core/resource/resource_cubit.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';

class ProfileCubit extends ResourceCubit<ProfileEntity> {
  ProfileCubit(this._repository);

  final ProfileRepository _repository;

  @override
  Stream<DataResult<ProfileEntity>> source() => _repository.watchProfile();
}