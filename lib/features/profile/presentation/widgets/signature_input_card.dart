import 'package:flutter/material.dart';

import '../state_management/edit_profile_cubit.dart';
import 'draw_signature_dialog.dart';

class SignatureInputCard extends StatelessWidget {
  final bool hasSignature;
  final EditProfileCubit cubit;
  final double widthScale;
  final String? fieldError;

  const SignatureInputCard({
    super.key,
    required this.hasSignature,
    required this.cubit,
    required this.widthScale,
    this.fieldError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Signature',
            style: TextStyle(
              color: const Color(0xFF00113A),
              fontSize: 12 * widthScale,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
              fontFamily: 'Alexandria',
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12 * widthScale),

        // Centered action buttons
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final signatureBytes =
                  await showDrawSignatureDialog(context);

                  if (signatureBytes != null) {
                    // Handle saving signature via cubit
                  }
                },
                child: Container(
                  width: 144 * widthScale,
                  height: 32 * widthScale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Draw',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF00113A),
                      fontSize: 12 * widthScale,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.24,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),

              SizedBox(width: 15 * widthScale),

              GestureDetector(
                onTap: () {
                  // Handle upload logic
                },
                child: Container(
                  width: 144 * widthScale,
                  height: 32 * widthScale,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Upload',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF00113A),
                      fontSize: 12 * widthScale,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.24,
                      fontFamily: 'Alexandria',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (fieldError != null) ...[
          SizedBox(height: 8 * widthScale),
          Text(
            fieldError!,
            style: TextStyle(
              color: Colors.red,
              fontSize: 12 * widthScale,
            ),
          ),
        ],
      ],
    );
  }
}