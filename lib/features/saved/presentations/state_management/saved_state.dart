import 'package:equatable/equatable.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';

enum SavedStatus { initial, loading, loaded }

class SavedState extends Equatable {
  const SavedState({
    this.status = SavedStatus.initial,
    this.favorites = const [],
  });

  final SavedStatus status;
  final List<PropertyEntity> favorites;

  bool get isLoading => status == SavedStatus.loading && favorites.isEmpty;
  bool get isEmpty => status == SavedStatus.loaded && favorites.isEmpty;

  SavedState copyWith({SavedStatus? status, List<PropertyEntity>? favorites}) {
    return SavedState(
      status: status ?? this.status,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  List<Object?> get props => [status, favorites];
}