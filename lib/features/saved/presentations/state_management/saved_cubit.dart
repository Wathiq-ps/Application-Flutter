import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/saved/domain/repositories/favorites_repository.dart';
import 'saved_state.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit(this._repository) : super(const SavedState()) {
    _repository.favoriteIdsListenable.addListener(_onFavoritesChanged);
    load();
  }

  final FavoritesRepository _repository;

  void _onFavoritesChanged() => load();

  Future<void> load() async {
    if (state.status != SavedStatus.loaded) {
      emit(state.copyWith(status: SavedStatus.loading));
    }
    final favorites = await _repository.loadFavorites();
    if (isClosed) return;
    emit(state.copyWith(status: SavedStatus.loaded, favorites: favorites));
  }

  @override
  Future<void> close() {
    _repository.favoriteIdsListenable.removeListener(_onFavoritesChanged);
    return super.close();
  }
}