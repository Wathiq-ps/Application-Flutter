import '../entities/create_property_entity.dart';

abstract class CreatePropertyRepository {
  Future<void> createProperty(CreatePropertyEntity property);
}