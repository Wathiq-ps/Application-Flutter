import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';
import '../constant/app_icons.dart';
import '../constant/strings.dart';

class PageSearchBar extends StatelessWidget {
  const PageSearchBar({
    super.key,
    required this.widthScale,
    this.onTap,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
  });

  final double widthScale;

  /// Home (inactive) mode: called when the bar is tapped.
  final VoidCallback? onTap;

  /// Search (active) mode: passing a controller makes the field editable.
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;

  bool get _isEditable => controller != null;

  @override
  Widget build(BuildContext context) {
    final double ws = widthScale;

    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(9999),
      borderSide: BorderSide(
        color: AppColors.primary.withValues(alpha: 0.3),
        width: 1,
      ),
    );

    final TextStyle textStyle = TextStyle(
      color: AppColors.textPrimary,
      fontSize: 14 * ws,
      fontWeight: FontWeight.w400,
      height: 17 / 14,
    );

    final Widget field = SizedBox(
      width: double.infinity,
      height: 50 * ws,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: !_isEditable,
          showCursor: _isEditable,
          canRequestFocus: _isEditable,
          enableInteractiveSelection: _isEditable,
          mouseCursor: _isEditable ? null : SystemMouseCursors.click,
          onTap: _isEditable ? null : onTap,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
          style: textStyle,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: AppColors.white,
            border: border,
            enabledBorder: border,
            focusedBorder: border,
            contentPadding: EdgeInsets.symmetric(vertical: 16 * ws),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 16 * ws, right: 5 * ws),
              child: SvgPicture.asset(
                AppIcons.searchUnselected,
                width: 18 * ws,
                height: 18 * ws,
                excludeFromSemantics: true,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            prefixIconConstraints: BoxConstraints(
              minWidth: 39 * ws,
              minHeight: 18 * ws,
            ),
            suffixIcon: _isEditable ? _buildClearButton(ws) : null,
            suffixIconConstraints: const BoxConstraints(minWidth: 0),
            hintText: AppStrings.searchByLocation,
            hintStyle: textStyle,
          ),
        ),
      ),
    );

    if (_isEditable) return field;

    // Home: behaves as one button for screen readers.
    return Semantics(
      button: true,
      label: AppStrings.searchByLocation,
      excludeSemantics: true,
      child: field,
    );
  }

  Widget _buildClearButton(double ws) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller!,
      builder: (context, value, _) {
        if (value.text.isEmpty) return const SizedBox.shrink();
        return GestureDetector(
          onTap: onClear,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16 * ws),
            child: SvgPicture.asset(
              AppIcons.x,
              width: 13.33 * ws,
              height: 13.33 * ws,
              colorFilter: ColorFilter.mode(
                AppColors.primary.withValues(alpha: 0.3),
                BlendMode.srcIn,
              ),
            ),
          ),
        );
      },
    );
  }
}