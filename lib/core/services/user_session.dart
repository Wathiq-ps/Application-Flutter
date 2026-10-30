import 'package:flutter/foundation.dart';

abstract final class UserSession {
  static final ValueNotifier<String> name = ValueNotifier<String>('');

  static String firstNameOf(String full) {
    final t = full.trim();
    return t.isEmpty ? '' : t.split(RegExp(r'\s+')).first;
  }
}