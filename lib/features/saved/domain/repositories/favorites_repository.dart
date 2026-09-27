import 'package:flutter/foundation.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';

abstract class FavoritesRepository {
  ValueListenable<Set<String>> get favoriteIdsListenable;
  bool isFavorite(String id);
  Future<void> toggleFavorite(PropertyEntity property);

  Future<void> removeFavorite(String id);

  Future<List<PropertyEntity>> loadFavorites();
}