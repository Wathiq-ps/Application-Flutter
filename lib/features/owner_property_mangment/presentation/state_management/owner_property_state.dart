import 'package:equatable/equatable.dart';
import 'package:mobile/core/resource/resource_state.dart';
import '../../domain/entities/owner_properties_page.dart';
import '../../domain/entities/owner_property_list_item.dart';

class OwnerPropertyState extends Equatable {
  const OwnerPropertyState({
    this.resource = const ResourceState<OwnerPropertiesPage>(),
    this.isLoadingMore = false,
  });

  final ResourceState<OwnerPropertiesPage> resource;
  final bool isLoadingMore;

  List<OwnerPropertyListItem> get properties => resource.data?.items ?? const [];
  bool get hasMore => resource.data?.hasMore ?? false;
  int get currentPage => resource.data?.currentPage ?? 1;

  OwnerPropertyState copyWith({
    ResourceState<OwnerPropertiesPage>? resource,
    bool? isLoadingMore,
  }) {
    return OwnerPropertyState(
      resource: resource ?? this.resource,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [resource, isLoadingMore];
}