import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/property/domain/entities/create_property_entity.dart';
import 'package:mobile/features/property/domain/repository/create_property_repository.dart';
import 'package:mobile/features/property/domain/usecases/create_property_usecase.dart';
import 'package:mobile/features/property/presentation/state_management/create_property_cubit.dart';
import 'package:mobile/features/property/presentation/state_management/create_property_state.dart';

class FakeCreatePropertyRepository implements CreatePropertyRepository {
  @override
  Future<void> createProperty(CreatePropertyEntity property) async {}
}

void main() {
  late CreatePropertyCubit cubit;

  setUp(() {
    final useCase = CreatePropertyUseCase(FakeCreatePropertyRepository());
    cubit = CreatePropertyCubit(createPropertyUseCase: useCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('CreatePropertyCubit Step 2 - Optional Fields & Validation', () {
    test('saveStep2 succeeds when buildingNumber and floorNumber are null/empty', () {
      cubit.saveStep2(
        city: 'Gaza',
        district: 'Al-Wehda',
        latitude: '31.5',
        longitude: '34.4',
        buildingNumber: null,
        floorNumber: null,
        areaSqm: 120.0,
        price: 50000.0,
        rooms: null,
        bathrooms: null,
      );

      expect(cubit.state.status, CreatePropertyStatus.step2Saved);
      expect(cubit.state.city, 'Gaza');
      expect(cubit.state.district, 'Al-Wehda');
      expect(cubit.state.latitude, '31.5');
      expect(cubit.state.longitude, '34.4');
      expect(cubit.state.buildingNumber, '');
      expect(cubit.state.floorNumber, isNull);
      expect(cubit.state.areaSqm, 120.0);
      expect(cubit.state.price, 50000.0);
      expect(cubit.state.errorMessage, isNull);
    });

    test('saveStep2 fails when required fields (e.g. area) are invalid', () {
      cubit.saveStep2(
        city: 'Gaza',
        district: 'Al-Wehda',
        latitude: '31.5',
        longitude: '34.4',
        buildingNumber: null,
        floorNumber: null,
        areaSqm: 0.0,
        price: 50000.0,
      );

      expect(cubit.state.status, CreatePropertyStatus.validationError);
      expect(cubit.state.errorMessage, 'Please enter a valid area');
    });
  });

  group('CreatePropertyCubit Step 3 - Optional Description', () {
    test('saveStep3 succeeds when description is null or empty', () {
      cubit.saveStep3(
        features: ['Elevator', 'Parking'],
        description: null,
      );

      expect(cubit.state.status, CreatePropertyStatus.step3Saved);
      expect(cubit.state.features, ['Elevator', 'Parking']);
      expect(cubit.state.description, '');
      expect(cubit.state.errorMessage, isNull);
    });
  });
}
