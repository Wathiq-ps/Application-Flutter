import 'package:equatable/equatable.dart';
import 'app_locale.dart';

class LocaleState extends Equatable {
  const LocaleState({required this.locale});

  final AppLocale locale;

  @override
  List<Object?> get props => [locale];
}