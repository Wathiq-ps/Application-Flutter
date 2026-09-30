import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile/core/di/injector.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/input_field.dart';
import '../../../../core/widget/page_header.dart';
import '../state_management/edit_profile_cubit.dart';
import '../state_management/edit_profile_state.dart';
import '../widgets/document_type_toggle.dart';
import '../widgets/nationality_picker_sheet.dart';
import '../widgets/signature_input_card.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditProfileCubit(Injector.editProfileRepository)..load(),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _nameController = TextEditingController();
  final _documentNumberController = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _documentNumberController.dispose();
    super.dispose();
  }

  /// Wraps a picked-image path as a [File] for [FileImage].
  File _asFile(String path) => File(path);

  Future<void> _pickDate(BuildContext context, EditProfileCubit cubit, DateTime? current) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) cubit.setDateOfBirth(picked);
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 852.0;
    final double ws = context.screenWidth / figmaWidth;
    final double hs = context.screenHeight / figmaHeight;
    final theme = Theme.of(context);
    final cubit = context.read<EditProfileCubit>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: BlocConsumer<EditProfileCubit, EditProfileState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: (context, state) {
            if (state.status == EditProfileStatus.ready && !_seeded) {
              _seeded = true;
              _nameController.text = state.name;
              _documentNumberController.text = state.documentNumber;
            }
            if (state.status == EditProfileStatus.saved) {
              AppTopSnackBar.show(
                context,
                title: AppStrings.profileUpdated,
                message: AppStrings.profileUpdated,
                prefixIcon: AppIcons.success,
              );
              context.pop(true);
            }
            if (state.status == EditProfileStatus.saveFailed && state.errorMessage != null) {
              AppTopSnackBar.show(
                context,
                title: AppStrings.somethingWentWrong,
                message: state.errorMessage!,
                prefixIcon: AppIcons.error,
              );
            }
          },
          builder: (context, state) {
            if (state.status == EditProfileStatus.loading || state.status == EditProfileStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.isLoadFailed) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? AppStrings.somethingWentWrong),
                    TextButton(onPressed: cubit.load, child: const Text(AppStrings.retry)),
                  ],
                ),
              );
            }

            return Column(
              children: [
                PageHeader(
                  widthScale: ws,
                  padding: EdgeInsets.symmetric(horizontal: 20 * ws, vertical: 12 * hs),
                  left: AppSvgIconButton(
                    widthScale: ws,
                    icon: AppIcons.backArrowProp,
                    iconWidth: 20,
                    iconHeight: 16,
                    onTap: () => context.pop(),
                  ),
                  center: Text(
                    AppStrings.editProfile,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontSize: 18 * ws,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.45,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 17 * ws, vertical: 16 * hs),
                    children: [
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final paths = await Injector.imagePickerService.pickImages(limit: 1);
                            if (paths.isNotEmpty) cubit.setLocalAvatarPath(paths.first);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 112 * ws,
                                height: 112 * ws,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8E8EA),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.white, width: 4 * ws),
                                  image: state.localAvatarPath != null
                                      ? DecorationImage(
                                    image: FileImage(_asFile(state.localAvatarPath!)),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: state.localAvatarPath == null
                                    ? Text(
                                  state.name.isNotEmpty ? state.name[0].toUpperCase() : 'U',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 48 * ws,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                                    : null,
                              ),
                              SizedBox(height: 12 * ws),
                              Text(
                                AppStrings.addPhoto,
                                style: TextStyle(
                                  color: const Color(0xFF0A1F44),
                                  fontSize: 12 * ws,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24 * hs),

                      _field(AppStrings.fullName, ws, hs,
                          InputFieldWidget(
                            controller: _nameController,
                            hint: AppStrings.fullName,
                            errorText: state.fieldErrors['name']?.first,
                            onChanged: cubit.setName,
                          )),

                      _field(AppStrings.dateOfBirth, ws, hs,
                          GestureDetector(
                            onTap: () => _pickDate(context, cubit, state.dateOfBirth),
                            child: AbsorbPointer(
                              child: InputFieldWidget(
                                controller: TextEditingController(
                                  text: state.dateOfBirth == null
                                      ? ''
                                      : DateFormat('dd / MM / yyyy').format(state.dateOfBirth!),
                                ),
                                hint: 'dd / mm / yyyy',
                              ),
                            ),
                          )),

                      _field(AppStrings.nationality, ws, hs,
                          GestureDetector(
                            onTap: () => showNationalityPicker(
                              context: context,
                              current: state.nationality,
                              widthScale: ws,
                              onSelected: cubit.setNationality,
                            ),
                            child: AbsorbPointer(
                              child: InputFieldWidget(
                                controller: TextEditingController(text: state.nationality),
                                hint: AppStrings.nationality,
                                errorText: state.fieldErrors['nationality']?.first,
                                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                              ),
                            ),
                          )),

                      _field(AppStrings.mobileNumber, ws, hs,
                          InputFieldWidget(
                            controller: TextEditingController(text: state.phone ?? ''),
                            hint: AppStrings.mobileNumber,
                            onChanged: cubit.setPhone, // TODO: not yet submitted (backend field pending)
                          )),

                      _field(AppStrings.enterEmail, ws, hs,
                          InputFieldWidget(
                            controller: TextEditingController(text: state.email),
                            hint: state.email,
                            onChanged: null, // email is read-only here
                          )),

                      SizedBox(height: 8 * hs),
                      Text(
                        AppStrings.documentType,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12 * ws,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.24,
                        ),
                      ),
                      SizedBox(height: 12 * ws),
                      DocumentTypeToggle(
                        value: state.documentType,
                        onChanged: cubit.setDocumentType,
                        widthScale: ws,
                      ),
                      SizedBox(height: 20 * hs),

                      _field(AppStrings.idNumber, ws, hs,
                          InputFieldWidget(
                            controller: _documentNumberController,
                            hint: AppStrings.idNumber,
                            errorText: state.fieldErrors['document_number']?.first,
                            onChanged: cubit.setDocumentNumber,
                          )),

                      SignatureInputCard(
                        hasSignature: state.hasSignatureToShow,
                        cubit: cubit,
                        widthScale: ws,
                        fieldError: state.fieldErrors['signature_image']?.first,
                      ),
                      SizedBox(height: 32 * hs),

                      AppElevatedButton(
                        text: AppStrings.saveChangesCta,
                        onPressed: state.isSaving ? null : cubit.save,
                        backgroundColor: AppColors.primary,
                        height: 56 * ws,
                        width: double.infinity,
                        borderRadius: 9999,
                        textStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14 * ws,
                        ),
                      ),
                      SizedBox(height: 24 * hs),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _field(String label, double ws, double hs, Widget input) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16 * hs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12 * ws,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.24,
            ),
          ),
          SizedBox(height: 8 * ws),
          input,
        ],
      ),
    );
  }
}