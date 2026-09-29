import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/resource/resource_loader.dart';
import 'package:mobile/core/resource/resource_state.dart';
import 'package:mobile/features/home/presentation/state_mangement/home_state.dart'
    show PropertyFilter;
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
  SearchCubit(this._repository) : super(const SearchState());

  final SearchRepository _repository;
  Timer? _debounce;
  int _requestId = 0;

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
      if (isClosed || id != _requestId) return; // a newer search started
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
      emit(state.copyWith(isLoadingMore: false)); // retried on next scroll
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}