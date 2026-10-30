import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../../domain/entities/edit_profile_user_entity.dart';

class DocumentTypeToggle extends StatelessWidget {
  const DocumentTypeToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.widthScale,
  });

  final ProfileDocumentType value;
  final ValueChanged<ProfileDocumentType> onChanged;
  final double widthScale;

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    return Container(
      height: 42 * ws,
      padding: EdgeInsets.all(4 * ws),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0x80C5C6CF)),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        children: [
          Expanded(child: _segment(AppStrings.nationalId, ProfileDocumentType.id, ws)),
          Expanded(child: _segment(AppStrings.passport, ProfileDocumentType.passport, ws)),
        ],
      ),
    );
  }

  Widget _segment(String label, ProfileDocumentType type, double ws) {
    final bool selected = value == type;
    return GestureDetector(
      onTap: () => onChanged(type),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
          boxShadow: selected
              ? [const BoxShadow(color: Color(0x0D000000), offset: Offset(0, 1), blurRadius: 2)]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : const Color(0xFF44464E),
            fontSize: 12 * ws,
            fontWeight: FontWeight.w400,
            height: 16 / 12,
            letterSpacing: 0.24,
          ),
        ),
      ),
    );
  }
}