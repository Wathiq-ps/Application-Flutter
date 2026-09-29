import 'package:equatable/equatable.dart';
import 'package:mobile/core/resource/resource_state.dart';
import 'package:mobile/features/home/presentation/state_mangement/home_state.dart'
    show PropertyFilter;
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../domain/entities/search_result_entity.dart';

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.appliedQuery = '',
    this.filter = PropertyFilter.all,
    this.resource = const ResourceState<SearchResultEntity>(),
    this.extraItems = const [],
    this.page = 1,
    this.isLoadingMore = false,
  });

  final String query;
  final String appliedQuery;
  final PropertyFilter filter;
  final ResourceState<SearchResultEntity> resource;
  final List<PropertyEntity> extraItems;
  final int page;
  final bool isLoadingMore;

  List<PropertyEntity> get items =>
      [...(resource.data?.items ?? const <PropertyEntity>[]), ...extraItems];

  int get total => resource.data?.total ?? 0;

  bool get hasMore => resource.data != null && page < resource.data!.lastPage;

  SearchState copyWith({
    String? query,
    String? appliedQuery,
    PropertyFilter? filter,
    ResourceState<SearchResultEntity>? resource,
    List<PropertyEntity>? extraItems,
    int? page,
    bool? isLoadingMore,
  }) {
    return SearchState(
      query: query ?? this.query,
      appliedQuery: appliedQuery ?? this.appliedQuery,
      filter: filter ?? this.filter,
      resource: resource ?? this.resource,
      extraItems: extraItems ?? this.extraItems,
      page: page ?? this.page,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props =>
      [query, appliedQuery, filter, resource, extraItems, page, isLoadingMore];
}