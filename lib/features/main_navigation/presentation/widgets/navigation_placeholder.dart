import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class NavigationPlaceholder extends StatelessWidget {
  const NavigationPlaceholder({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: AppColors.primary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}