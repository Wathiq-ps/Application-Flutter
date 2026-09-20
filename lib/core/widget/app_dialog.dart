import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_style.dart';
import '../extensions/media_query_extensions.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.icon,
    required this.iconWidth ,
    required this.iconHeight,
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
  final double iconWidth;
  final double iconHeight;
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
        required double iconWidth ,
        required double iconHeight ,
        bool barrierDismissible = true,
        Color barrierColor = const Color(0xA100113A),
      }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (_) => AppDialog(
        title: title,
        message: message,
        icon: icon,
        iconHeight: iconWidth ,
        iconWidth: iconWidth,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadius * widthScale),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
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
                child: Container(
                  width: 64 * widthScale,
                  height: 64 * widthScale,
                  decoration: BoxDecoration(
                    color: (primaryBackgroundColor ?? colorScheme.primary)
                        .withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    icon!,
                    width: iconWidth * widthScale,
                    height: iconHeight * widthScale,
                  ),
                ),
              ),
              SizedBox(height: 16 * widthScale),
            ],


            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.bold(
                fontSize: 18 * widthScale,
                color: colorScheme.onSurface,
                height: 22 / 18,
                letterSpacing: 0.24,
              ),
            ),

            if (content != null) ...[
              SizedBox(height: 8 * widthScale),
              content!,
            ] else if (message != null && message!.trim().isNotEmpty) ...[
              SizedBox(height: 8 * widthScale),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontSize: 13 * widthScale,
                  fontWeight: FontWeight.w400,
                  height: 18 / 13,
                  letterSpacing: 0.24,
                ),
              ),
            ],

            if (primaryText != null && secondaryText != null) ...[
              SizedBox(height: 24 * widthScale),
              Row(
                children: [
                  Expanded(
                    child:AppElevatedButton(
                      text: secondaryText!,
                      onPressed: onSecondary ?? () => Navigator.of(context).pop(),
                      backgroundColor: colorScheme.surface,
                      enableBorder: true,
                      borderColor: AppColors.border,
                      borderWidth: 1,
                      height: 48 * widthScale,
                      borderRadius: 14 * widthScale,
                      elevation: 0,
                      textStyle: textTheme.labelMedium?.copyWith(
                        color: secondaryTextColor ?? colorScheme.onSurface,
                        fontSize: 14 * widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: 12 * widthScale),
                  Expanded(
                    child: AppElevatedButton(
                      text: primaryText!,
                      onPressed: onPrimary,
                      backgroundColor: primaryBackgroundColor ?? colorScheme.primary,
                      height: 48 * widthScale,
                      borderRadius: 14 * widthScale,
                      elevation: 0,
                      textStyle: textTheme.labelMedium?.copyWith(
                        color: primaryTextColor ?? colorScheme.onPrimary,
                        fontSize: 14 * widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (primaryText != null) ...[
              SizedBox(height: 20 * widthScale),
              AppElevatedButton(
                text: primaryText!,
                onPressed: onPrimary,
                backgroundColor: primaryBackgroundColor ?? colorScheme.primary,
                height: 48 * widthScale,
                borderRadius: 14 * widthScale,
                elevation: 0,
                textStyle: textTheme.labelMedium?.copyWith(
                  color: primaryTextColor ?? colorScheme.onPrimary,
                  fontSize: 14 * widthScale,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ] else if (secondaryText != null) ...[
              SizedBox(height: 12 * widthScale),
              TextButton(
                onPressed: onSecondary ?? () => Navigator.of(context).pop(),
                style: theme.textButtonTheme.style,
                child: Text(
                  secondaryText!,
                  style: textTheme.labelSmall?.copyWith(
                    color: secondaryTextColor ?? colorScheme.onSurface,
                    fontSize: 12 * widthScale,
                    fontWeight: FontWeight.w500,
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