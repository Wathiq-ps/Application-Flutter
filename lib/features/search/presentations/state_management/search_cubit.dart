import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/resource/resource_loader.dart';
import 'package:mobile/core/resource/resource_state.dart';
import 'package:mobile/features/home/presentation/state_mangement/home_state.dart'
    show PropertyFilter;
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import 'package:mobile/features/saved/domain/repositories/favorites_repository.dart';
import '../../domain/entities/search_result_entity.dart';
import '../../domain/repository/search_repository.dart';
import 'search_state.dart';

extension PropertyFilterApi on PropertyFilter {
  String? get apiValue => switch (this) {
    PropertyFilter.all => null,
    PropertyFilter.sale => 'sale',
    PropertyFilter.rent => 'rent',
  };
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository, this._favorites)
      : super(SearchState(
    favoriteIds: Set<String>.from(_favorites.favoriteIdsListenable.value),
  )) {
    _favorites.favoriteIdsListenable.addListener(_onFavoritesChanged);
  }

  final SearchRepository _repository;
  final FavoritesRepository _favorites;
  Timer? _debounce;
  int _requestId = 0;

  // ── Favourites ──────────────────────────────────────────

  void _onFavoritesChanged() {
    if (isClosed) return;
    emit(state.copyWith(
      favoriteIds: Set<String>.from(_favorites.favoriteIdsListenable.value),
    ));
  }

  Future<void> toggleFavorite(PropertyEntity property) =>
      _favorites.toggleFavorite(property);

  // ── Search ──────────────────────────────────────────────

  void onQueryChanged(String value) {
    emit(state.copyWith(query: value));
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), search);
  }

  void submit() => search();

  void clearQuery() {
    emit(state.copyWith(query: ''));
    search();
  }

  void changeFilter(PropertyFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
    search();
  }

  Future<void> search({bool refresh = false}) async {
    _debounce?.cancel();
    final int id = ++_requestId;
    final String query = state.query.trim();
    final String? listing = state.filter.apiValue;

    final loader = ResourceLoader<SearchResultEntity>(
          () => _repository.watchSearch(query: query, listingType: listing),
    );

    final ResourceState<SearchResultEntity> base =
    refresh ? state.resource : const ResourceState<SearchResultEntity>();

    if (!refresh) {
      emit(state.copyWith(
        appliedQuery: query,
        resource: base,
        extraItems: const [],
        page: 1,
        isLoadingMore: false,
      ));
    }

    await for (final r in loader.load(base)) {
      if (isClosed || id != _requestId) return;
      emit(state.copyWith(
        appliedQuery: query,
        resource: r,
        extraItems: const [],
        page: 1,
      ));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.resource.isRefreshing) {
      return;
    }
    final int id = _requestId;
    final int next = state.page + 1;
    emit(state.copyWith(isLoadingMore: true));

    try {
      final result = await _repository.fetchPage(
        query: state.appliedQuery,
        listingType: state.filter.apiValue,
        page: next,
      );
      if (isClosed || id != _requestId) return;
      emit(state.copyWith(
        extraItems: [...state.extraItems, ...result.items],
        page: next,
        isLoadingMore: false,
      ));
    } catch (_) {
      if (isClosed || id != _requestId) return;
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    _favorites.favoriteIdsListenable.removeListener(_onFavoritesChanged);
    return super.close();
  }
}