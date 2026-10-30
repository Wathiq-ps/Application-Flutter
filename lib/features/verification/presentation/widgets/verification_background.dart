import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/images_path.dart';

/// Full-screen background image + legibility gradient (Figma "MainContainer"
/// and "Gradient Overlay for Legibility").
class VerificationBackground extends StatelessWidget {
  const VerificationBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: Image.asset(ImagePath.background, fit: BoxFit.cover),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.overlayLight,
                  AppColors.overlayMedium,
                  AppColors.overlayDark,
                ],
                stops: [0.0, 0.40, 1.0],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}