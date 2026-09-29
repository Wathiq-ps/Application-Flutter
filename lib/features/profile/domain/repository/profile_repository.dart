import 'package:mobile/core/cache/data_result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Stream<DataResult<ProfileEntity>> watchProfile();
}