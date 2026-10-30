import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

enum PropertyStatus {
  active,
  review,
  rejected,
  suspended;

  static PropertyStatus fromApi(String? value) {
    switch (value) {
      case 'active':
        return PropertyStatus.active;

      case 'rejected':
        return PropertyStatus.rejected;

      case 'suspended':
        return PropertyStatus.suspended;

      case 'pending_verification':
      case 'review':
      default:
        return PropertyStatus.review;
    }
  }
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
        return AppColors.propertyActiveBg;

      case PropertyStatus.review:
        return AppColors.propertyReviewBg;

      case PropertyStatus.rejected:
        return AppColors.propertyRejectedBg;

      case PropertyStatus.suspended:
        return AppColors.propertySuspendedBg;
    }
  }

  Color get dotColor {
    switch (this) {
      case PropertyStatus.active:
        return AppColors.propertyActiveDot;

      case PropertyStatus.review:
        return AppColors.propertyReviewDot;

      case PropertyStatus.rejected:
        return AppColors.propertyRejectedDot;

      case PropertyStatus.suspended:
        return AppColors.propertySuspendedDot;
    }
  }

  Color get textColor {
    switch (this) {
      case PropertyStatus.active:
        return AppColors.propertyActiveText;

      case PropertyStatus.review:
        return AppColors.propertyReviewText;

      case PropertyStatus.rejected:
        return AppColors.propertyRejectedText;

      case PropertyStatus.suspended:
        return AppColors.propertySuspendedText;
    }
  }
}