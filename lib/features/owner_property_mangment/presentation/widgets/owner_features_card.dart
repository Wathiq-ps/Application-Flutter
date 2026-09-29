import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_dropdown_option_tile.dart';
import '../../../../core/widget/app_icon_label_trigger.dart';

class OwnerFeaturesCard extends StatelessWidget {
  const OwnerFeaturesCard({
    super.key,
    required this.selected,
    required this.widthScale,
    required this.onChanged,
  });

  final List<String> selected;
  final double widthScale;
  final ValueChanged<List<String>> onChanged;

  static const List<String> _knownKeys = [
    'parking',
    'garden',
    'water',
    'elevator',
    'electricity',
    'wifi',
  ];

  static String labelFor(String key) {
    switch (key) {
      case 'parking':
        return AppStrings.parking;
      case 'garden':
        return AppStrings.garden;
      case 'water':
        return AppStrings.water;
      case 'elevator':
        return AppStrings.elevator;
      case 'electricity':
        return AppStrings.electricity;
      case 'wifi':
        return AppStrings.wifi;
      default:
        return key.isEmpty ? key : '${key[0].toUpperCase()}${key.substring(1)}';
    }
  }

  Future<void> _openSheet(BuildContext context) async {
    final double ws = widthScale;
    final List<String> options = [
      ..._knownKeys,
      ...selected.where((k) => !_knownKeys.contains(k)),
    ];
    final Set<String> current = {...selected};

    final List<String>? result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22 * ws)),
              ),
              padding: EdgeInsets.fromLTRB(20 * ws, 12 * ws, 20 * ws, 20 * ws),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 36 * ws,
                      height: 4 * ws,
                      margin: EdgeInsets.only(bottom: 12 * ws),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  Text(
                    AppStrings.selectFeatures,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16 * ws,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.24,
                    ),
                  ),
                  SizedBox(height: 12 * ws),
                  ...options.map((key) {
                    return AppDropdownOptionTile(
                      widthScale: ws,
                      label: labelFor(key),
                      isSelected: current.contains(key),
                      onTap: () => setSheetState(() {
                        if (!current.add(key)) current.remove(key);
                      }),
                    );
                  }),
                  SizedBox(height: 12 * ws),
                  GestureDetector(
                    onTap: () => Navigator.of(sheetContext).pop(
                      options.where(current.contains).toList(),
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: double.infinity,
                      height: 48 * ws,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12 * ws),
                      ),
                      child: Text(
                        AppStrings.done,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14 * ws,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final double ws = widthScale;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15 * ws),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(16 * ws),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.features,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12 * ws,
                  fontWeight: FontWeight.w700,
                  height: 16 / 12,
                  letterSpacing: 0.24,
                ),
              ),
              AppLabelIconTrigger(
                widthScale: ws,
                label: AppStrings.editAction,
                icon: AppIcons.edit,
                onTap: () => _openSheet(context),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
                iconColor: AppColors.primary,
                iconWidth: 12,
                iconHeight: 12,
                switchIconText: true,
              ),
            ],
          ),
          SizedBox(height: 10 * ws),
          GestureDetector(
            onTap: () => _openSheet(context),
            behavior: HitTestBehavior.opaque,
            child: selected.isEmpty
                ? Text(
              AppStrings.noFeaturesSelected,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 14 * ws,
                fontWeight: FontWeight.w500,
              ),
            )
                : Wrap(
              spacing: 8 * ws,
              runSpacing: 8 * ws,
              children: selected.map((key) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10 * ws,
                    vertical: 6 * ws,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20 * ws),
                  ),
                  child: Text(
                    labelFor(key),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12 * ws,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}