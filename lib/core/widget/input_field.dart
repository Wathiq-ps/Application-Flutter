import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../extensions/media_query_extensions.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.hint,
    this.errorText,
    this.onChanged,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final widthScale = context.widthScale;
    final heightScale = context.heightScale;

    const double figmaBorderRadius = 12;
    const double figmaHorizontalPadding = 16;
    const double figmaVerticalPadding = 16;
    const double figmaFontSize = 16;
    const double figmaLineHeight = 24;

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      obscureText: obscureText,
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: figmaFontSize * widthScale,
        height: figmaLineHeight / figmaFontSize,
      ),
      decoration: InputDecoration(
        hintText: hint,

        // Cubit validation error.
        errorText: errorText,

        filled: true,
        fillColor: AppColors.white,

        contentPadding: EdgeInsets.symmetric(
          horizontal: figmaHorizontalPadding * widthScale,
          vertical: figmaVerticalPadding * heightScale,
        ),

        floatingLabelBehavior: FloatingLabelBehavior.never,

        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,

        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,

        hintStyle: textTheme.bodyLarge?.copyWith(
          color: AppColors.textSecondary,
          fontSize: figmaFontSize * widthScale,
          height: figmaLineHeight / figmaFontSize,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            figmaBorderRadius * widthScale,
          ),
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            figmaBorderRadius * widthScale,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            figmaBorderRadius * widthScale,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            figmaBorderRadius * widthScale,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 1.5,
          ),
        ),

        errorStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.error,
          fontSize: 12 * widthScale,
        ),
      ),
    );
  }
}
