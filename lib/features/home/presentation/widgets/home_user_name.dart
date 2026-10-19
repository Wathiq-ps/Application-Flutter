import 'package:flutter/material.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/services/user_session.dart';
import '../../../profile/domain/entities/profile_entity.dart';

class HomeUserName extends StatefulWidget {
  const HomeUserName({super.key, required this.builder});

  final Widget Function(BuildContext context, String firstName) builder;

  @override
  State<HomeUserName> createState() => _HomeUserNameState();
}

class _HomeUserNameState extends State<HomeUserName> {
  @override
  void initState() {
    super.initState();
    if (UserSession.name.value.isEmpty) _load();
  }

  Future<void> _load() async {
    try {
      final result = await Injector.profileRepository.watchProfile().first;
      final name = (result.data as ProfileEntity).name;
      if (name.trim().isNotEmpty) UserSession.name.value = name;
    } catch (_) {
      // Not signed in or offline: the greeting just says "Hello".
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: UserSession.name,
      builder: (context, full, _) =>
          widget.builder(context, UserSession.firstNameOf(full)),
    );
  }
}