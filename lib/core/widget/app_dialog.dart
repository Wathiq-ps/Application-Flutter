import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';
import '../extensions/media_query_extensions.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.iconSize = 40,
    this.primaryText,
    this.onPrimary,
    this.secondaryText,
    this.onSecondary,
    this.primaryBackgroundColor,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.width = 348,
    this.minHeight = 232,
    this.borderRadius = 22,
    this.horizontalPadding = 24,
    this.verticalPadding = 24,
    this.barrierDismissible = true,
    this.content,
  });

  final String title;
  final String? message;
  final String? icon;
  final double iconSize;
  final String? primaryText;
  final VoidCallback? onPrimary;
  final String? secondaryText;
  final VoidCallback? onSecondary;
  final Color? primaryBackgroundColor;
  final Color? primaryTextColor;
  final Color? secondaryTextColor;
  final double width;
  final double minHeight;
  final double borderRadius;
  final double horizontalPadding;
  final double verticalPadding;
  final bool barrierDismissible;
  final Widget? content;

  static Future<T?> show<T>(
      BuildContext context, {
        required String title,
        String? message,
        String? icon,
        String? primaryText,
        VoidCallback? onPrimary,
        String? secondaryText,
        VoidCallback? onSecondary,
        Color? primaryBackgroundColor,
        Color? primaryTextColor,
        Color? secondaryTextColor,
        Widget? content,
        bool barrierDismissible = true,
      }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.black.withValues(alpha: 0.35),
      builder: (_) => AppDialog(
        title: title,
        message: message,
        icon: icon,
        primaryText: primaryText,
        onPrimary: onPrimary,
        secondaryText: secondaryText,
        onSecondary: onSecondary,
        primaryBackgroundColor: primaryBackgroundColor,
        primaryTextColor: primaryTextColor,
        secondaryTextColor: secondaryTextColor,
        content: content,
        barrierDismissible: barrierDismissible,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    final double widthScale = context.screenWidth / figmaWidth;

    final double scaledWidth = width * widthScale;
    final double maxWidth = context.screenWidth - (32 * widthScale);

    return Dialog(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 16 * widthScale),
      child: Container(
        width: scaledWidth > maxWidth ? maxWidth : scaledWidth,
        constraints: BoxConstraints(minHeight: minHeight * widthScale),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding * widthScale,
          vertical: verticalPadding * widthScale,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius * widthScale),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.25),
              blurRadius: 7.3 * widthScale,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (icon != null) ...[
              Center(
                child: SvgPicture.asset(
                  icon!,
                  width: iconSize * widthScale,
                  height: iconSize * widthScale,
                ),
              ),
              SizedBox(height: 12 * widthScale),
            ],

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16 * widthScale,
                fontWeight: FontWeight.w700,
                height: 22 / 16,
                letterSpacing: 0.24,
              ),
            ),

            if (content != null) ...[
              SizedBox(height: 10 * widthScale),
              content!,
            ] else if (message != null && message!.trim().isNotEmpty) ...[
              SizedBox(height: 10 * widthScale),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12 * widthScale,
                  fontWeight: FontWeight.w400,
                  height: 18 / 12,
                  letterSpacing: 0.24,
                ),
              ),
            ],

            if (primaryText != null) ...[
              SizedBox(height: 20 * widthScale),
              AppElevatedButton(
                text: primaryText!,
                onPressed: onPrimary,
                backgroundColor: primaryBackgroundColor ?? AppColors.primary,
                height: 48 * widthScale,
                borderRadius: 9999,
                elevation: 0,
                textStyle: TextStyle(
                  color: primaryTextColor ?? AppColors.white,
                  fontSize: 14 * widthScale,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],

            if (secondaryText != null) ...[
              SizedBox(height: 8 * widthScale),
              TextButton(
                onPressed: onSecondary ?? () => Navigator.of(context).pop(),
                child: Text(
                  secondaryText!,
                  style: TextStyle(
                    color: secondaryTextColor ?? AppColors.textPrimary,
                    fontSize: 11 * widthScale,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.44,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}