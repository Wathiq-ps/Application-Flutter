import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/localization/locale_state.dart';
import '../../../../core/widget/app_dropdown_option_tile.dart';

Future<void> showLanguagePicker({
  required BuildContext context,
  required double widthScale,
}) {
  final localeCubit = context.read<LocaleCubit>();

  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetContext) {
      final double maxHeight = MediaQuery.of(sheetContext).size.height * 0.5;

      return BlocBuilder<LocaleCubit, LocaleState>(
        bloc: localeCubit,
        builder: (context, state) {
          return Container(
            constraints: BoxConstraints(maxHeight: maxHeight),
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
                  AppStrings.selectLanguage,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18 * widthScale,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 12 * widthScale),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      AppDropdownOptionTile(
                        widthScale: widthScale,
                        label: AppStrings.languageEnglish,
                        isSelected: state.locale == AppLocale.en,
                        onTap: () {
                          localeCubit.setLocale(AppLocale.en);
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                      AppDropdownOptionTile(
                        widthScale: widthScale,
                        label: AppStrings.languageArabic,
                        isSelected: state.locale == AppLocale.ar,
                        onTap: () {
                          localeCubit.setLocale(AppLocale.ar);
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}