import 'package:dio/dio.dart';
import 'package:mobile/core/constant/api_constants.dart';
import 'package:mobile/core/services/secure_storage_service.dart';

import '../models/create_property_model.dart';

abstract class CreatePropertyRemoteDataSource {
  Future<void> createProperty(CreatePropertyModel property);
}

class CreatePropertyRemoteDataSourceImpl
    implements CreatePropertyRemoteDataSource {
  final Dio dio;
  final SecureStorageService secureStorageService;

  CreatePropertyRemoteDataSourceImpl(
    this.dio, {
    this.secureStorageService = const SecureStorageService(),
  });

  @override
  Future<void> createProperty(CreatePropertyModel property) async {
    final token = await secureStorageService.getAccessToken();
    final formData = FormData();

    formData.fields.add(MapEntry('listing_type', property.listingType));

    formData.fields.add(MapEntry('type', property.type));

    formData.fields.add(MapEntry('city', property.city));

    formData.fields.add(MapEntry('district', property.district));

    if (property.buildingNumber != null) {
      formData.fields.add(MapEntry('building_number', property.buildingNumber!));
    }

    formData.fields.add(MapEntry('latitude', property.latitude.toString()));

    formData.fields.add(MapEntry('longitude', property.longitude.toString()));

    formData.fields.add(MapEntry('area_sqm', property.areaSqm.toString()));

    formData.fields.add(MapEntry('price', property.price.toString()));

    formData.fields.add(MapEntry('price_currency', property.priceCurrency));

    if (property.priceUnit != null) {
      formData.fields.add(MapEntry('price_unit', property.priceUnit!));
    }

    formData.fields.add(MapEntry('rooms', property.rooms.toString()));

    formData.fields.add(MapEntry('bathrooms', property.bathrooms.toString()));
    if (property.floorNumber != null) {
      formData.fields.add(
        MapEntry('floor_number', property.floorNumber.toString()),
      );
    }

    formData.fields.add(
      MapEntry('is_furnished', property.isFurnished.toString()),
    );
    for (final photo in property.photos) {
      formData.files.add(
        MapEntry('photos', await MultipartFile.fromFile(photo.path)),
      );
    }
    for (final document in property.ownershipDocuments) {
      formData.files.add(
        MapEntry(
          'ownership_documents',
          await MultipartFile.fromFile(document.path),
        ),
      );
    }

    await dio.post(
      ApiConstants.createPropertyEndPoint,
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );
  }
}
