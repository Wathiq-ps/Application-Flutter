import 'package:flutter/material.dart';

enum AppLocale {
  en,
  ar;

  String get code => this == AppLocale.ar ? 'ar' : 'en';
  Locale get locale => Locale(code);

  static AppLocale fromCode(String code) => code == 'ar' ? AppLocale.ar : AppLocale.en;

  static AppLocale? fromDeviceLocale(Locale deviceLocale) {
    for (final l in AppLocale.values) {
      if (l.code == deviceLocale.languageCode) return l;
    }
    return null;
  }
}