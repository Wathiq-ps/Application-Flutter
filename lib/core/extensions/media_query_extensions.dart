import 'package:flutter/material.dart';

extension MediaQueryExtension on BuildContext {
  // Existing screen dimension getters
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  Size get screenSize => MediaQuery.sizeOf(this);

  double get safeScreenHeight =>
      screenHeight - MediaQuery.paddingOf(this).vertical;

  // Orientations
  bool get isPortrait =>
      MediaQuery.orientationOf(this) == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery.orientationOf(this) == Orientation.landscape;

  // System paddings & insets
  double get topPadding => MediaQuery.paddingOf(this).top;
  double get bottomPadding => MediaQuery.paddingOf(this).bottom;
  double get leftPadding => MediaQuery.paddingOf(this).left;
  double get rightPadding => MediaQuery.paddingOf(this).right;

  double get textScaleFactor => MediaQuery.textScalerOf(this).scale(1.0);
  double get keyboardBottomInset => MediaQuery.viewInsetsOf(this).bottom;

  // Responsive typography
  double responsiveFont(double size) {
    final scale = (screenWidth / 375.0).clamp(0.85, 1.3);
    return size * scale;
  }

  // Figma 393 x 852 design baselines
  double get widthScale => screenWidth / 393.0;
  double get heightScale => screenHeight / 852.0;

  // Breakpoints
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;

  // Responsive layouts & spacing
  double get pageHorizontalPadding {
    if (isDesktop) return 48;
    if (isTablet) return 32;
    return 24;
  }

  double get pageVerticalPadding {
    if (isDesktop) return 48;
    if (isTablet) return 32;
    return 24;
  }

  double get bottomNavigationBarHeight {
    if (isDesktop) return 88;
    if (isTablet) return 80;
    return 64;
  }

  double get authFormMaxWidth {
    if (isDesktop) return 520;
    if (isTablet) return 480;
    return double.infinity;
  }
}
