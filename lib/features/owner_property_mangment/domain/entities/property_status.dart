import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

enum PropertyStatus {
  active,
  review,
  rejected,
  suspended;

  String get label {
    switch (this) {
      case PropertyStatus.active:
        return AppStrings.statusActive;
      case PropertyStatus.review:
        return AppStrings.statusReview;
      case PropertyStatus.rejected:
        return AppStrings.statusRejected;
      case PropertyStatus.suspended:
        return AppStrings.statusSuspended;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case PropertyStatus.active:
        return const Color(0xE6D1FAE5);
      case PropertyStatus.review:
        return const Color(0xE6FFCFA8);
      case PropertyStatus.rejected:
        return const Color(0xE6BE1510);
      case PropertyStatus.suspended:
        return const Color(0xE67B7B7B);
    }
  }

  Color get dotColor {
    switch (this) {
      case PropertyStatus.active:
        return const Color(0xFF059669);
      case PropertyStatus.review:
        return const Color(0xFFFF6805);
      case PropertyStatus.rejected:
        return const Color(0xFFFFD1D0);
      case PropertyStatus.suspended:
        return const Color(0xFF464646);
    }
  }

  Color get textColor {
    switch (this) {
      case PropertyStatus.active:
        return const Color(0xFF065F46);
      case PropertyStatus.review:
        return const Color(0xFFFF6805);
      case PropertyStatus.rejected:
        return const Color(0xFFFFD1D0);
      case PropertyStatus.suspended:
        return const Color(0xFF464646);
    }
  }
}