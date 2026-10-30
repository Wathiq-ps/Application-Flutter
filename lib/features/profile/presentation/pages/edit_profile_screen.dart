import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:mobile/core/di/injector.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/app_profile_avatar.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/app_top_snackbar.dart';
import '../../../../core/widget/input_field.dart';
import '../../../../core/widget/page_header.dart';
import '../state_management/edit_profile_cubit.dart';
import '../state_management/edit_profile_state.dart';
import '../widgets/document_type_toggle.dart';
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
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();

  String _phoneIso = 'PS';
  bool _seeded = false;

  static String _iso(String? v) =>
      (v != null && v.trim().length == 2) ? v.trim().toUpperCase() : 'PS';

  static final DateFormat _dobFormat = DateFormat('dd / MM / yyyy');

  @override
  void dispose() {
    _nameController.dispose();
    _documentNumberController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(EditProfileCubit cubit) async {
    final paths = await Injector.imagePickerService.pickImages(limit: 1);
    if (paths.isNotEmpty) cubit.setLocalAvatarPath(paths.first);
  }

  Future<void> _pickDate(
      BuildContext context,
      EditProfileCubit cubit,
      DateTime? current,
      ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime(1990, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = _dobFormat.format(picked);
      cubit.setDateOfBirth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double ws = context.widthScale;
    final double hs = context.heightScale;
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
              _phoneController.text = state.phone ?? '';
              _emailController.text = state.email;
              _dobController.text = state.dateOfBirth == null
                  ? ''
                  : _dobFormat.format(state.dateOfBirth!);
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
            if (state.status == EditProfileStatus.saveFailed &&
                state.errorMessage != null) {
              AppTopSnackBar.show(
                context,
                title: AppStrings.somethingWentWrong,
                message: state.errorMessage!,
                prefixIcon: AppIcons.error,
              );
            }
          },
          builder: (context, state) {
            if (state.status == EditProfileStatus.loading ||
                state.status == EditProfileStatus.initial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.isLoadFailed) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.errorMessage ?? AppStrings.somethingWentWrong),
                    TextButton(
                      onPressed: cubit.load,
                      child: Text(AppStrings.retry),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                PageHeader(
                  widthScale: ws,
                  padding: EdgeInsets.symmetric(horizontal: 20 * ws),
                  left: AppSvgIconButton(
                    widthScale: ws,
                    icon: AppIcons.backArrowProp,
                    iconWidth: 20 * ws,
                    iconHeight: 16 * ws,
                    flipForRtl: true,
                    onTap: () => context.pop(),
                  ),
                  center: Text(
                    AppStrings.editProfile,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.primary,
                      fontSize: 18 * ws,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.45,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 17 * ws,
                      vertical: 16 * hs,
                    ),
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 112 * ws,
                              height: 112 * ws,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 36 * ws,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                    child: AppProfileAvatar(
                                      widthScale: ws,
                                      size: 112,
                                      imageFile: state.localAvatarPath != null
                                          ? File(state.localAvatarPath!)
                                          : null,
                                      initialsSource: state.name,
                                      showInitialsFallback: true,
                                      backgroundColor: const Color(0xFFE8E8EA),
                                      initialsColor: AppColors.primary,
                                      borderColor: AppColors.white,
                                      borderWidth: 4,
                                    ),
                                  ),
                                  PositionedDirectional(
                                    end: 0,
                                    bottom: 2 * ws,
                                    child: GestureDetector(
                                      onTap: () => _pickAvatar(cubit),
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: 32 * ws,
                                        height: 32 * ws,
                                        alignment: Alignment.center,
                                        child: SvgPicture.asset(
                                          AppIcons.camera,
                                          width: 14 * ws,
                                          height: 14 * ws,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.primary,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12 * ws),
                            GestureDetector(
                              onTap: () => _pickAvatar(cubit),
                              child: Text(
                                AppStrings.addPhoto,
                                style: TextStyle(
                                  color: const Color(0xFF0A1F44),
                                  fontSize: 12 * ws,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24 * hs),

                      _field(
                        AppStrings.fullName,
                        ws,
                        hs,
                        InputFieldWidget(
                          controller: _nameController,
                          hint: AppStrings.fullName,
                          errorText: state.fieldErrors['name']?.first,
                          onChanged: cubit.setName,
                        ),
                      ),

                      _field(
                        AppStrings.dateOfBirth,
                        ws,
                        hs,
                        GestureDetector(
                          onTap: () =>
                              _pickDate(context, cubit, state.dateOfBirth),
                          child: AbsorbPointer(
                            child: InputFieldWidget(
                              controller: _dobController,
                              hint: 'dd / mm / yyyy',
                            ),
                          ),
                        ),
                      ),

                      _field(
                        AppStrings.nationality,
                        ws,
                        hs,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0x4D00113A)),
                            borderRadius: BorderRadius.circular(8 * ws),
                          ),
                          child: CountryCodePicker(
                            onChanged: (country) =>
                                cubit.setNationality(country.code ?? 'PS'),
                            initialSelection: _iso(state.nationality),
                            showCountryOnly: true,
                            showOnlyCountryWhenClosed: true,
                            alignLeft: true,
                            textStyle: TextStyle(
                              color: const Color(0xB200113A),
                              fontSize: 14 * ws,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Alexandria',
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8 * ws,
                              vertical: 4 * hs,
                            ),
                          ),
                        ),
                      ),

                      _field(
                        AppStrings.mobileNumber,
                        ws,
                        hs,
                        InputFieldWidget(
                          controller: _phoneController,
                          hint: '593216070',
                          onChanged: cubit.setPhone,
                          prefixIcon: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CountryCodePicker(
                                  onChanged: (country) => setState(
                                        () => _phoneIso = country.code ?? 'PS',
                                  ),
                                  initialSelection: _phoneIso,
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false,
                                  showFlag: false,
                                  padding: EdgeInsets.zero,
                                  textStyle: TextStyle(
                                    color: const Color(0xB200113A),
                                    fontSize: 14 * ws,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xB200113A),
                                  size: 16 * ws,
                                ),
                                SizedBox(width: 8 * ws),
                              ],
                            ),
                          ),
                        ),
                      ),

                      _field(
                        AppStrings.enterEmail,
                        ws,
                        hs,
                        InputFieldWidget(
                          controller: _emailController,
                          hint: state.email,
                          onChanged: null,
                        ),
                        isRequired: false,
                      ),

                      SizedBox(height: 8 * hs),
                      RichText(
                        text: TextSpan(
                          text: AppStrings.documentType,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12 * ws,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.24,
                            fontFamily: 'Alexandria',
                          ),
                          children: const [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12 * ws),
                      DocumentTypeToggle(
                        value: state.documentType,
                        onChanged: cubit.setDocumentType,
                        widthScale: ws,
                      ),
                      SizedBox(height: 20 * hs),

                      _field(
                        AppStrings.idNumber,
                        ws,
                        hs,
                        InputFieldWidget(
                          controller: _documentNumberController,
                          hint: AppStrings.idNumber,
                          errorText: state.fieldErrors['document_number']?.first,
                          onChanged: cubit.setDocumentNumber,
                        ),
                      ),

                      SignatureInputCard(
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

  Widget _field(
      String label,
      double ws,
      double hs,
      Widget input, {
        bool isRequired = true,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16 * hs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12 * ws,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.24,
                fontFamily: 'Alexandria',
              ),
              children: isRequired
                  ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                  : [],
            ),
          ),
          SizedBox(height: 8 * ws),
          input,
        ],
      ),
    );
  }
}
