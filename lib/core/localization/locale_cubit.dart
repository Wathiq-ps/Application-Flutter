import 'dart:ui' show PlatformDispatcher;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_locale.dart';
import 'locale_state.dart';
import 'locale_storage_service.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._storage) : super(const LocaleState(locale: AppLocale.en));

  final LocaleStorageService _storage;

  Future<void> load() async {
    final saved = await _storage.read();
    if (saved != null) {
      emit(LocaleState(locale: saved));
      return;
    }

    final device = PlatformDispatcher.instance.locale;
    final matched = AppLocale.fromDeviceLocale(device) ?? AppLocale.en;
    emit(LocaleState(locale: matched));
  }

  Future<void> setLocale(AppLocale locale) async {
    if (locale == state.locale) return;
    emit(LocaleState(locale: locale));
    await _storage.save(locale);
  }
}