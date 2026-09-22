import '../../domain/entities/create_property_entity.dart';
import '../../domain/repository/create_property_repository.dart';
import '../data_sources/create_property_remote_data_source.dart';
import '../models/create_property_model.dart';

class CreatePropertyRepositoryImpl implements CreatePropertyRepository {
  final CreatePropertyRemoteDataSource remoteDataSource;

  CreatePropertyRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createProperty(CreatePropertyEntity property) {
    final model = CreatePropertyModel.fromEntity(property);

    return remoteDataSource.createProperty(model);
  }
}
