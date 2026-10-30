import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../state_management/edit_profile_cubit.dart';
import '../state_management/edit_profile_state.dart';
import 'draw_signature_dialog.dart';

class SignatureInputCard extends StatelessWidget {
  final EditProfileCubit cubit;
  final double widthScale;
  final String? fieldError;

  const SignatureInputCard({
    super.key,
    required this.cubit,
    required this.widthScale,
    this.fieldError,
  });

  Future<void> _draw(BuildContext context) async {
    final bytes = await showDrawSignatureDialog(context);
    if (bytes != null) cubit.setDrawnSignature(bytes); // replaces an upload
  }

  Future<void> _upload(BuildContext context) async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) cubit.setUploadedSignature(picked.path); // replaces a drawing
    } catch (_) {
      if (!context.mounted) return;
      AppTopSnackBar.show(
        context,
        title: AppStrings.somethingWentWrong,
        message: AppStrings.imagePickFailed,
        prefixIcon: AppIcons.error,
      );
    }
  }

  Widget _button(String label, VoidCallback onTap, bool selected) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 144 * widthScale,
        height: 32 * widthScale,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
            ),
          ],
          borderRadius: BorderRadius.circular(9999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF00113A),
            fontSize: 12 * widthScale,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: 0.24,
            fontFamily: 'Alexandria',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditProfileCubit, EditProfileState>(
      bloc: cubit,
      buildWhen: (p, c) =>
      p.pendingSignature != c.pendingSignature ||
          p.hasExistingSignature != c.hasExistingSignature,
      builder: (context, state) {
        final pending = state.pendingSignature;
        final drawn = pending != null && pending.bytes != null;
        final uploaded = pending != null && pending.bytes == null;

        final String status;
        final Color statusColor;
        if (pending != null) {
          status = drawn ? AppStrings.signatureDrawn : AppStrings.signatureUploaded;
          statusColor = AppColors.primary;
        } else if (state.hasExistingSignature) {
          status = AppStrings.signatureSaved;
          statusColor = AppColors.primary;
        } else {
          status = AppStrings.noSignatureYet;
          statusColor = const Color(0xB200113A);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: AppStrings.signature,
                style: TextStyle(
                  color: const Color(0xFF00113A),
                  fontSize: 12 * widthScale,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.24,
                  fontFamily: 'Alexandria',
                ),
                children: const [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 12 * widthScale),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _button(AppStrings.draw, () => _draw(context), drawn),
                  SizedBox(width: 15 * widthScale),
                  _button(AppStrings.upload, () => _upload(context), uploaded),
                ],
              ),
            ),
            SizedBox(height: 10 * widthScale),
            Center(
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 11 * widthScale,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Alexandria',
                ),
              ),
            ),
            if (fieldError != null) ...[
              SizedBox(height: 8 * widthScale),
              Text(
                fieldError!,
                style: TextStyle(color: Colors.red, fontSize: 12 * widthScale),
              ),
            ],
          ],
        );
      },
    );
  }
}