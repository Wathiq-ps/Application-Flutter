import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/config/routes/routes_names.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/constant/strings.dart';

import 'package:mobile/features/verification/presentation/cubit/verification_cubit.dart';
import 'package:mobile/features/verification/presentation/widgets/action_button.dart';
import 'package:mobile/features/verification/presentation/widgets/dashed_border_painter.dart';
import 'package:mobile/features/verification/presentation/widgets/requirement_item.dart';

class VerifyIdentityScreen extends StatefulWidget {
  const VerifyIdentityScreen({super.key});

  @override
  State<VerifyIdentityScreen> createState() => _VerifyIdentityScreenState();
}

class _VerifyIdentityScreenState extends State<VerifyIdentityScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 90,
      );

      if (image == null || !mounted) return;

      context.read<VerificationCubit>().setIdImage(image);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(AppStrings.somethingWentWrong)));
    }
  }

  void _continue() {
    if (context.read<VerificationCubit>().idImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your ID first')),
      );
      return;
    }
    context.go(RouteNames.verifySelfieIdentityScreen);
  }

  @override
  Widget build(BuildContext context) {
    final idImage = context.watch<VerificationCubit>().idImage;
    return Scaffold(
      body: Stack(
        children: [
          // =========================
          // Background
          // =========================
          Positioned.fill(
            child: Image.asset(ImagePath.background, fit: BoxFit.cover),
          ),

          Positioned.fill(
            child: Container(color: const Color(0xff001B4D).withOpacity(0.72)),
          ),

          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Container(color: Colors.transparent),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // =========================
                // Header
                // =========================
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 10),

                          const Expanded(
                            child: Text(
                              AppStrings.verifyYourIdentity,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      const Text(
                        AppStrings.step1Of2,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // =========================
                // Main content
                // =========================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 2),
                    child: Column(
                      children: [
                        // =========================
                        // Upload Card
                        // =========================
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          decoration: BoxDecoration(
                            color: const Color(0xff8392B8).withOpacity(0.72),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.12),
                            ),
                          ),
                          child: Column(
                            children: [
                              const Text(
                                AppStrings.uploadYourId,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 7),

                              const Text(
                                AppStrings.takeClearPhotoOfId,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  height: 1.45,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 20),

                              // =========================
                              // Upload Area
                              // =========================
                              GestureDetector(
                                onTap: () {
                                  _pickImage(ImageSource.gallery);
                                },
                                child: CustomPaint(
                                  painter: DashedBorderPainter(
                                    color: Colors.white.withOpacity(0.65),
                                    strokeWidth: 2,
                                    dashWidth: 8,
                                    dashSpace: 6,
                                    radius: 18,
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: idImage == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff001B4D),
                                                ),
                                                child: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              ),

                                              const SizedBox(height: 10),

                                              const Text(
                                                AppStrings.tapToUpload,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 19,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Image.file(
                                              File(idImage!.path),
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // =========================
                              // Camera + Gallery buttons
                              // =========================
                              Row(
                                children: [
                                  Expanded(
                                    child: ActionButton(
                                      icon: Icons.camera_alt_outlined,
                                      text: AppStrings.tapToUpload,
                                      onTap: () {
                                        _pickImage(ImageSource.camera);
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 18),

                                  Expanded(
                                    child: ActionButton(
                                      icon: Icons.image_outlined,
                                      text: AppStrings.gallery,
                                      onTap: () {
                                        _pickImage(ImageSource.gallery);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // =========================
                        // Requirements
                        // =========================
                        const RequirementItem(
                          text: AppStrings.faceAndIdClearlyVisible,
                        ),

                        const SizedBox(height: 11),

                        const RequirementItem(
                          text: AppStrings.goodLightingNoShadows,
                        ),

                        const SizedBox(height: 11),

                        const RequirementItem(
                          text: AppStrings.removeSunglassesOrHats,
                        ),

                        const SizedBox(height: 11),

                        // =========================
                        // Continue Button
                        // =========================
                        SizedBox(
                          width: double.infinity,
                          height: 66,
                          child: ElevatedButton(
                            onPressed: _continue,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff001B4D),
                              foregroundColor: Colors.white,
                              elevation: 8,
                              shadowColor: Colors.black.withOpacity(0.35),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(35),
                              ),
                            ),
                            child: const Text(
                              AppStrings.continueText,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
