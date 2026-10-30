import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/resource/resource_loader.dart';
import '../../domain/entities/owner_properties_page.dart';
import '../../domain/repositories/owner_property_repository.dart';
import 'owner_property_state.dart';

class OwnerPropertyCubit extends Cubit<OwnerPropertyState> {
  OwnerPropertyCubit(this._repository)
      : _loader = ResourceLoader<OwnerPropertiesPage>(_repository.watchMyProperties),
        super(const OwnerPropertyState());

  final OwnerPropertyRepository _repository;
  final ResourceLoader<OwnerPropertiesPage> _loader;

  Future<void> load() async {
    if (state.resource.isRefreshing) return;
    await for (final r in _loader.load(state.resource)) {
      if (isClosed) return;
      emit(state.copyWith(resource: r));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || !state.resource.hasData) return;

    emit(state.copyWith(isLoadingMore: true));
    try {
      final next = await _repository.fetchPage(state.currentPage + 1);
      final current = state.resource.data!;
      final merged = OwnerPropertiesPage(
        items: [...current.items, ...next.items],
        currentPage: next.currentPage,
        lastPage: next.lastPage,
        total: next.total,
      );
      if (isClosed) return;
      emit(state.copyWith(
        resource: state.resource.copyWith(data: merged),
        isLoadingMore: false,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(isLoadingMore: false));
    }
  }
}