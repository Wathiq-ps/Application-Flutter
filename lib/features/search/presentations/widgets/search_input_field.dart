import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    required this.widthScale,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final double widthScale;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final double ws = widthScale;

    return Container(
      width: double.infinity,
      height: 50 * ws,
      padding: EdgeInsets.symmetric(horizontal: 16 * ws),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.searchUnselected,
            width: 18 * ws,
            height: 18 * ws,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 5 * ws),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              maxLines: 1,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14 * ws,
                fontWeight: FontWeight.w400,
                height: 17 / 14,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: AppStrings.searchByLocation,
                hintStyle: TextStyle(
                  color: AppColors.textPrimary.withValues(alpha: 0.6),
                  fontSize: 14 * ws,
                  fontWeight: FontWeight.w400,
                  height: 17 / 14,
                ),
              ),
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return GestureDetector(
                onTap: onClear,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.all(4 * ws),
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
          ),
        ],
      ),
    );
  }
}