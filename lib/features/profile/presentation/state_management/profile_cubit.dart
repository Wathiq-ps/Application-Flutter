import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/cache/data_result.dart';
import 'package:mobile/core/resource/resource_cubit.dart';
import 'package:mobile/core/resource/resource_state.dart';
import 'package:mobile/core/services/user_session.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repository/profile_repository.dart';

class ProfileCubit extends ResourceCubit<ProfileEntity> {
  ProfileCubit(this._repository);

  final ProfileRepository _repository;

  @override
  Stream<DataResult<ProfileEntity>> source() => _repository.watchProfile();

  @override
  void onChange(Change<ResourceState<ProfileEntity>> change) {
    super.onChange(change);
    final name = change.nextState.data?.name;
    if (name != null && name.trim().isNotEmpty) {
      UserSession.name.value = name;
    }
  }
}