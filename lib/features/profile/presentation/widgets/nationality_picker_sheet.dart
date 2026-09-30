import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_dropdown_option_tile.dart';

const List<String> _nationalities = [
  'Palestinian', 'Jordanian', 'Egyptian', 'Lebanese', 'Syrian', 'Iraqi',
  'Saudi', 'Emirati', 'Kuwaiti', 'Qatari', 'Other',
];

Future<void> showNationalityPicker({
  required BuildContext context,
  required String current,
  required double widthScale,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24 * widthScale)),
        ),
        padding: EdgeInsets.fromLTRB(20 * widthScale, 12 * widthScale, 20 * widthScale, 24 * widthScale),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40 * widthScale,
              height: 4 * widthScale,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10 * widthScale),
              ),
            ),
            SizedBox(height: 20 * widthScale),
            Text(
              AppStrings.selectNationality,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18 * widthScale,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12 * widthScale),
            ..._nationalities.map((n) {
              return AppDropdownOptionTile(
                widthScale: widthScale,
                label: n,
                isSelected: n == current,
                onTap: () {
                  onSelected(n);
                  Navigator.of(sheetContext).pop();
                },
              );
            }),
          ],
        ),
      );
    },
  );
}