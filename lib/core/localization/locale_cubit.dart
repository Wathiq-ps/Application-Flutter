import 'dart:ui' show PlatformDispatcher;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/api_locale.dart';
import 'app_locale.dart';
import 'locale_state.dart';
import 'locale_storage_service.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._storage) : super(const LocaleState(locale: AppLocale.en));

  final LocaleStorageService _storage;

  void _apply(AppLocale locale) {
    ApiLocale.code = locale.code;
    emit(LocaleState(locale: locale));
  }

  Future<void> load() async {
    final saved = await _storage.read();
    if (saved != null) {
      _apply(saved);
      return;
    }
    final device = PlatformDispatcher.instance.locale;
    _apply(AppLocale.fromDeviceLocale(device) ?? AppLocale.en);
  }

  Future<void> setLocale(AppLocale locale) async {
    if (locale == state.locale) return;
    _apply(locale);
    await _storage.save(locale);
  }
}