import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/create_property_entity.dart';
import '../../domain/usecases/create_property_usecase.dart';
import 'create_property_state.dart';

class CreatePropertyCubit extends Cubit<CreatePropertyState> {
  final CreatePropertyUseCase _createPropertyUseCase;

  CreatePropertyCubit({required CreatePropertyUseCase createPropertyUseCase})
    : _createPropertyUseCase = createPropertyUseCase,
      super(const CreatePropertyState());
  void saveStep1({
    required String listingType,
    required String type,
    String? customType,
  }) {
    if (listingType.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please select listing type',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (type.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please select property type',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (type == 'other' && (customType == null || customType.trim().isEmpty)) {
      emit(
        state.copyWith(
          errorMessage: 'Please specify property type',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        listingType: listingType,
        type: type,
        customType: customType,
        errorMessage: null,
        status: CreatePropertyStatus.step1Saved,
      ),
    );
  }

  void saveStep2({
    required String city,
    required String district,
    required String latitude,
    required String longitude,
    String? buildingNumber,
    int? floorNumber,
    required double? areaSqm,
    required double? price,
    int? rooms,
    int? bathrooms,
    String? priceCurrency,
    String? priceUnit,
  }) {
    if (city.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please select city',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (district.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please select district',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (latitude.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please enter latitude',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (longitude.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please enter longitude',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (areaSqm == null || areaSqm <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Please enter a valid area',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    if (price == null || price <= 0) {
      emit(
        state.copyWith(
          errorMessage: 'Please enter a valid price',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        city: city,
        district: district,
        latitude: latitude,
        longitude: longitude,
        buildingNumber: buildingNumber ?? '',
        floorNumber: floorNumber,
        areaSqm: areaSqm,
        price: price,
        rooms: rooms,
        bathrooms: bathrooms,
        priceCurrency: (priceCurrency != null && priceCurrency.isNotEmpty)
            ? priceCurrency
            : (state.priceCurrency.isNotEmpty ? state.priceCurrency : 'JOD'),
        priceUnit: priceUnit ?? state.priceUnit,
        errorMessage: null,
        status: CreatePropertyStatus.step2Saved,
      ),
    );
  }

  void saveStep3({required List<String> features, String? description}) {
    emit(
      state.copyWith(
        features: features,
        description: description ?? '',
        errorMessage: null,
        status: CreatePropertyStatus.step3Saved,
      ),
    );
  }

  void saveStep4({required List<String> photos}) {
    if (photos.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please add at least one photo',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        photos: photos,
        errorMessage: null,
        status: CreatePropertyStatus.step4Saved,
      ),
    );
  }

  void saveStep5({
    required List<String> proofPhotos,
    required List<PlatformFile> proofDocuments,
    String? ownershipDocumentType,
  }) {
    if (proofPhotos.isEmpty && proofDocuments.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'Please upload at least one document or photo',
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        proofPhotos: proofPhotos,
        proofDocuments: proofDocuments,
        ownershipDocumentType:
            ownershipDocumentType ?? state.ownershipDocumentType,
        errorMessage: null,
        status: CreatePropertyStatus.step5Saved,
      ),
    );
  }

  void listingTypeChanged(String value) {
    emit(
      state.copyWith(
        listingType: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void typeChanged(String value) {
    emit(
      state.copyWith(
        type: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void cityChanged(String value) {
    emit(
      state.copyWith(
        city: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void districtChanged(String value) {
    emit(
      state.copyWith(
        district: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void buildingNumberChanged(String value) {
    emit(
      state.copyWith(
        buildingNumber: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void latitudeChanged(String value) {
    emit(
      state.copyWith(
        latitude: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void longitudeChanged(String value) {
    emit(
      state.copyWith(
        longitude: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void descriptionChanged(String value) {
    emit(
      state.copyWith(
        description: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void featuresChanged(List<String> value) {
    emit(
      state.copyWith(
        features: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void photosChanged(List<String> value) {
    emit(
      state.copyWith(
        photos: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void proofPhotosChanged(List<String> value) {
    emit(
      state.copyWith(
        proofPhotos: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void proofDocumentsChanged(List<PlatformFile> value) {
    emit(
      state.copyWith(
        proofDocuments: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void ownershipDocumentTypeChanged(String value) {
    emit(
      state.copyWith(
        ownershipDocumentType: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void isFurnishedChanged(bool? value) {
    emit(
      state.copyWith(
        isFurnished: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void priceChanged(double? value) {
    emit(
      state.copyWith(
        price: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void priceCurrencyChanged(String value) {
    emit(
      state.copyWith(
        priceCurrency: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void priceUnitChanged(String value) {
    emit(
      state.copyWith(
        priceUnit: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void areaSqmChanged(double? value) {
    emit(
      state.copyWith(
        areaSqm: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void roomsChanged(int? value) {
    emit(
      state.copyWith(
        rooms: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  void bathroomsChanged(int? value) {
    emit(
      state.copyWith(
        bathrooms: value,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );
  }

  Future<void> createProperty() async {
    final validationError = _validate();

    if (validationError != null) {
      emit(
        state.copyWith(
          errorMessage: validationError,
          status: CreatePropertyStatus.validationError,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errorMessage: null,
        status: CreatePropertyStatus.initial,
      ),
    );

    final photoFiles = state.proofPhotos.map((path) => File(path)).toList();

    final documentFiles = state.proofDocuments
        .where((file) => file.path != null)
        .map((file) => File(file.path!))
        .toList();

    List<File> combinedOwnershipDocuments = [...photoFiles, ...documentFiles];

    final photos = state.photos.map((path) => File(path)).toList();

    final isFurnished = state.features.contains('furnished');

    final apiFeatures = state.features
        .where((feature) => feature != 'furnished')
        .toList();
    final property = CreatePropertyEntity(
      listingType: state.listingType,
      type: state.type,
      city: state.city,
      district: state.district,
      buildingNumber: state.buildingNumber.isNotEmpty
          ? state.buildingNumber
          : null,
      latitude: state.latitude,
      longitude: state.longitude,
      areaSqm: state.areaSqm!,
      price: state.price!,
      priceCurrency: state.priceCurrency,
      priceUnit: state.listingType.toLowerCase() == 'sale'
          ? null
          : (state.priceUnit.isNotEmpty ? state.priceUnit : null),
      rooms: state.rooms,
      bathrooms: state.bathrooms,
      floorNumber: state.floorNumber,
      features: apiFeatures.isNotEmpty ? apiFeatures : null,
      isFurnished: isFurnished,
      description: state.description.isNotEmpty ? state.description : null,
      photos: photos,
      ownershipDocuments: combinedOwnershipDocuments,
      ownershipDocumentType: state.ownershipDocumentType,
    );

    try {
      await _createPropertyUseCase(property);

      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: null,
          status: CreatePropertyStatus.created,
        ),
      );
    } catch (e) {
      print('Error creating property: $e');
      // 👇 أضف هذا الجزء هنا:
      if (e is DioException) {
        print('❌ Status Code: ${e.response?.statusCode}');
        print('❌ Response Data: ${e.response?.data}');
      }
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
          status: CreatePropertyStatus.createError,
        ),
      );
    }
  }

  void reset() {
    emit(const CreatePropertyState());
  }

  String? _validate() {
    if (state.listingType.isEmpty) {
      return 'Please select listing type';
    }

    if (state.type.isEmpty) {
      return 'Please select property type';
    }

    if (state.city.isEmpty) {
      return 'Please select city';
    }

    if (state.district.isEmpty) {
      return 'Please enter district';
    }

    if (state.latitude.isEmpty) {
      return 'Please enter latitude';
    }

    if (state.longitude.isEmpty) {
      return 'Please enter longitude';
    }

    if (state.price == null || state.price! <= 0) {
      return 'Please enter a valid price';
    }

    if (state.priceCurrency.isEmpty) {
      return 'Please select price currency';
    }

    if (state.listingType.toLowerCase() == 'rent' && state.priceUnit.isEmpty) {
      return 'Please select price unit';
    }

    if (state.areaSqm == null || state.areaSqm! <= 0) {
      return 'Please enter a valid area';
    }

    if (state.photos.isEmpty) {
      return 'Please add at least one photo';
    }

    if (state.ownershipDocumentType.isEmpty) {
      return 'Please select ownership document type';
    }

    if (state.proofDocuments.isEmpty && state.proofPhotos.isEmpty) {
      return 'Please upload proof of ownership';
    }

    return null;
  }
}
