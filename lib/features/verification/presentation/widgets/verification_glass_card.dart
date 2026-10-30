import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/extensions/media_query_extensions.dart';

/// Blurred translucent card used on both verification steps
/// (Figma "Overlay+Border+Shadow+OverlayBlur").
class VerificationGlassCard extends StatelessWidget {
  const VerificationGlassCard({
    super.key,
    required this.child,
    this.showGlow = false,
  });

  final Widget child;

  /// Decorative blurred glow in the top corner (step 2 only).
  final bool showGlow;

  @override
  Widget build(BuildContext context) {
    final widthScale = context.widthScale;
    final radius = BorderRadius.circular(12 * widthScale);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            offset: Offset(0, 10 * widthScale),
            blurRadius: 15 * widthScale,
            spreadRadius: -3 * widthScale,
          ),
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.1),
            offset: Offset(0, 4 * widthScale),
            blurRadius: 6 * widthScale,
            spreadRadius: -4 * widthScale,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.cardSelectedBg,
              border: Border.all(color: AppColors.cardBorder),
              borderRadius: radius,
            ),
            child: Stack(
              children: [
                if (showGlow)
                  Positioned(
                    right: -75 * widthScale,
                    top: -39 * widthScale,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                      child: Container(
                        width: 160 * widthScale,
                        height: 163 * widthScale,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // rgba(0, 85, 204, 0.3) from Figma
                          color: const Color(0xFF0055CC)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(24 * widthScale),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}