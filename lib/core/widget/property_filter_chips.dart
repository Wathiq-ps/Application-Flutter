import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../constant/strings.dart';

class PropertyFilterChips extends StatefulWidget {
  const PropertyFilterChips({
    super.key,
    required this.widthScale,
    this.initialIndex = 0,
    this.onChanged,
  });

  final double widthScale;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  @override
  State<PropertyFilterChips> createState() => _PropertyFilterChipsState();
}

class _PropertyFilterChipsState extends State<PropertyFilterChips> {
  late int _selectedIndex = widget.initialIndex;

  final List<String> _filters = const [
    AppStrings.forSale,
    AppStrings.forRent,
  ];

  @override
  Widget build(BuildContext context) {
    final widthScale = widget.widthScale;

    return SizedBox(
      height: 44 * widthScale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => SizedBox(width: 7 * widthScale),
        itemBuilder: (context, index) {
          final bool selected = index == _selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onChanged?.call(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: 36 * widthScale,
              padding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.white,
                borderRadius: BorderRadius.circular(9999),
                border: Border.all(
                  color: selected
                      ? AppColors.white
                      : AppColors.filterChipUnselectedBorderColor,
                ),
                boxShadow: selected
                    ? [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.05),
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
                  color: selected ? AppColors.white : AppColors.primary,
                  fontSize: 12 * widthScale,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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