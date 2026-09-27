import 'package:equatable/equatable.dart';
import 'package:mobile/core/resource/resource_state.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../domain/entities/home_data_entity.dart';

/// Chips: index 0 = For Sale, index 1 = For Rent. `all` = nothing selected.
enum PropertyFilter {
  all,
  sale,
  rent;

  int? get chipIndex => switch (this) {
    PropertyFilter.all => null,
    PropertyFilter.sale => 0,
    PropertyFilter.rent => 1,
  };

  static PropertyFilter fromChipIndex(int? index) => switch (index) {
    0 => PropertyFilter.sale,
    1 => PropertyFilter.rent,
    _ => PropertyFilter.all,
  };

  bool matches(PropertyEntity p) => switch (this) {
    PropertyFilter.all => true,
    PropertyFilter.sale => p.listingType == PropertyListingType.sale,
    PropertyFilter.rent => p.listingType == PropertyListingType.rent,
  };
}


class HomeState extends Equatable {
  final ResourceState<HomeDataEntity> resource;
  final PropertyFilter filter;

  const HomeState({
    this.resource = const ResourceState<HomeDataEntity>(),
    this.filter = PropertyFilter.all,
  });

  List<PropertyEntity> get featured => resource.data?.featured ?? const [];

  List<PropertyEntity> get filteredProperties =>
      (resource.data?.topRated ?? const <PropertyEntity>[])
          .where(filter.matches)
          .toList();

  HomeState copyWith({ResourceState<HomeDataEntity>? resource, PropertyFilter? filter}) =>
      HomeState(resource: resource ?? this.resource, filter: filter ?? this.filter);

  @override
  List<Object?> get props => [resource, filter];
}