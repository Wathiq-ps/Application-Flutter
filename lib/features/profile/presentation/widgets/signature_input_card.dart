import 'package:flutter/material.dart';
import 'package:mobile/core/di/injector.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';
import '../state_management/edit_profile_cubit.dart';
import 'draw_signature_dialog.dart';

class SignatureInputCard extends StatelessWidget {
  const SignatureInputCard({
    super.key,
    required this.hasSignature,
    required this.cubit,
    required this.widthScale,
    this.fieldError,
  });

  final bool hasSignature;
  final EditProfileCubit cubit;
  final double widthScale;
  final String? fieldError;

  Future<void> _upload(BuildContext context) async {
    final paths = await Injector.imagePickerService.pickImages(limit: 1);
    if (paths.isNotEmpty) cubit.setUploadedSignature(paths.first);
  }

  Future<void> _draw(BuildContext context) async {
    final bytes = await showDrawSignatureDialog(context);
    if (bytes != null) cubit.setDrawnSignature(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.signature,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 12 * ws,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.24,
          ),
        ),
        SizedBox(height: 12 * ws),
        Container(
          height: 42 * ws,
          padding: EdgeInsets.all(4 * ws),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: const Color(0x80C5C6CF)),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Row(
            children: [
              Expanded(
                child: _button(
                  label: AppStrings.draw,
                  filled: true,
                  ws: ws,
                  onTap: () => _draw(context),
                ),
              ),
              Expanded(
                child: _button(
                  label: AppStrings.upload,
                  filled: false,
                  ws: ws,
                  onTap: () => _upload(context),
                ),
              ),
            ],
          ),
        ),
        if (hasSignature) ...[
          SizedBox(height: 8 * ws),
          Text(
            'Signature saved ✓',
            style: TextStyle(color: AppColors.success, fontSize: 11 * ws),
          ),
        ],
        if (fieldError != null) ...[
          SizedBox(height: 6 * ws),
          Text(fieldError!, style: TextStyle(color: AppColors.error, fontSize: 11 * ws)),
        ],
      ],
    );
  }

  Widget _button({
    required String label,
    required bool filled,
    required double ws,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF0A1F44) : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: filled ? AppColors.white : const Color(0xFF44464E),
            fontSize: 12 * ws,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.24,
          ),
        ),
      ),
    );
  }
}