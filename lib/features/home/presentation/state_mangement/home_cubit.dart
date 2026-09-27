import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/resource/resource_loader.dart';
import '../../domain/entities/home_data_entity.dart';
import '../../domain/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(HomeRepository repository)
      : _loader = ResourceLoader<HomeDataEntity>(repository.watchHome),
        super(const HomeState());

  final ResourceLoader<HomeDataEntity> _loader;

  Future<void> loadHome() async {
    if (state.resource.isRefreshing) return;
    await for (final resource in _loader.load(state.resource)) {
      if (isClosed) return;
      emit(state.copyWith(resource: resource));
    }
  }

  void changeFilter(PropertyFilter filter) {
    if (filter == state.filter) return;
    emit(state.copyWith(filter: filter));
  }
}