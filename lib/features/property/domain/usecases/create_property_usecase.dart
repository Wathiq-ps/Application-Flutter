import '../entities/create_property_entity.dart';
import '../repository/create_property_repository.dart';

class CreatePropertyUseCase {
  final CreatePropertyRepository repository;

  CreatePropertyUseCase(this.repository);

  Future<void> call(CreatePropertyEntity property) {
    return repository.createProperty(property);
  }
}