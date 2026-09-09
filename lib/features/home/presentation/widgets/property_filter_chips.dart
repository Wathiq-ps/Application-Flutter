import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

class PropertyFilterChips extends StatefulWidget {
  const PropertyFilterChips({
    super.key,
  });

  @override
  State<PropertyFilterChips> createState() =>
      _PropertyFilterChipsState();
}

class _PropertyFilterChipsState
    extends State<PropertyFilterChips> {
  int _selectedIndex = 0;

  final List<String> _filters = const [
    AppStrings.forSale,
    AppStrings.forRent,
  ];

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;

    final double widthScale =
        MediaQuery.sizeOf(context).width / figmaWidth;

    return SizedBox(
      height: 44 * widthScale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) {
          return SizedBox(
            width: 7 * widthScale,
          );
        },
        itemBuilder: (context, index) {
          final bool selected = index == _selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 36 * widthScale,
              padding: EdgeInsets.symmetric(
                horizontal: 20 * widthScale,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF0A1F44)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: selected
                      ? AppColors.white
                      : const Color(0xB3C5C6CF),
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: AppColors.black.withValues(
                      alpha: 0.05,
                    ),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: selected
                      ? AppColors.white
                      : const Color(0xFF0A1F44),
                  fontSize: 12 * widthScale,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  height: 16 / 12,
                  letterSpacing: 0.24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}