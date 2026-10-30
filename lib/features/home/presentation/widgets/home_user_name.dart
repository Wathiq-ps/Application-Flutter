import 'package:flutter/foundation.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/services/user_session.dart';

Future<String> loadHomeUserName() async {
  if (UserSession.name.value.isEmpty) {
    try {
      final result = await Injector.profileRepository.watchProfile().first;
      final name = result.data.name;
      if (name.trim().isNotEmpty) UserSession.name.value = name;
    } catch (error, stackTrace) {
      debugPrint('Failed to load the home user name: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  return UserSession.firstNameOf(UserSession.name.value);
}
