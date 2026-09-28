import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/cache/data_result.dart';
import 'resource_loader.dart';
import 'resource_state.dart';

abstract class ResourceCubit<T> extends Cubit<ResourceState<T>> {
  ResourceCubit() : super(ResourceState<T>());

  @protected
  Stream<DataResult<T>> source();

  late final ResourceLoader<T> _loader = ResourceLoader<T>(source);

  Future<void> load() async {
    if (state.isRefreshing) return;
    await for (final s in _loader.load(state)) {
      if (isClosed) return;
      emit(s);
    }
  }
}