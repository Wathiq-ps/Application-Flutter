import 'package:flutter/foundation.dart';
import 'package:mobile/features/property/data/models/property_model.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import 'package:mobile/features/saved/domain/repositories/favorites_repository.dart';
import 'package:mobile/features/saved/data/data_sources/favorites_local_data_source.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl(this._localDataSource) {
    _ready = _loadFromDisk();
  }

  final FavoritesLocalDataSource _localDataSource;

  final List<String> _order = [];
  final Map<String, PropertyEntity> _items = {};
  final ValueNotifier<Set<String>> _idsNotifier = ValueNotifier<Set<String>>(const {});

  late final Future<void> _ready;

  @override
  ValueListenable<Set<String>> get favoriteIdsListenable => _idsNotifier;

  @override
  bool isFavorite(String id) => _idsNotifier.value.contains(id);

  Future<void> _loadFromDisk() async {
    try {
      final data = await _localDataSource.readAll();
      final order = data['order'] as List<String>;
      final items = data['items'] as Map<String, dynamic>;

      _order
        ..clear()
        ..addAll(order.where((id) => items[id] != null));

      _items.clear();
      for (final id in List<String>.from(_order)) {
        try {
          _items[id] = PropertyModel.fromJson(items[id] as Map<String, dynamic>);
        } catch (_) {
          _order.remove(id); // corrupt entry for this one property: drop it
        }
      }
      _idsNotifier.value = _order.toSet();
    } catch (_) {
      // Nothing usable on disk: start empty rather than failing the screen.
    }
  }

  @override
  Future<void> toggleFavorite(PropertyEntity property) async {
    await _ready;

    if (_items.containsKey(property.id)) {
      _order.remove(property.id);
      _items.remove(property.id);
    } else {
      _order.insert(0, property.id);
      _items[property.id] = property;
    }
    _idsNotifier.value = Set<String>.from(_order); // new instance -> notifies

    await _persist();
  }

  @override
  Future<void> removeFavorite(String id) async {
    await _ready;
    if (!_items.containsKey(id)) return;

    _order.remove(id);
    _items.remove(id);
    _idsNotifier.value = Set<String>.from(_order);

    await _persist();
  }

  @override
  Future<List<PropertyEntity>> loadFavorites() async {
    await _ready;
    return _order.map((id) => _items[id]!).toList();
  }

  Future<void> _persist() async {
    final items = <String, dynamic>{
      for (final id in _order) id: PropertyModel.fromEntity(_items[id]!).toJson(),
    };
    try {
      await _localDataSource.writeAll(order: _order, items: items);
    } catch (_) {
    }
  }
}