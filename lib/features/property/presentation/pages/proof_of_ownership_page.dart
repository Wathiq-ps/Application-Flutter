import 'dart:io';
 
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/widget/app_button.dart';
import 'package:mobile/features/property/presentation/widgets/submit_button_widget.dart';

import '../../../../config/routes/routes_names.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/services/file_picker_service.dart';
import '../../../../core/services/image_picker_service.dart';
import '../../../../core/widget/dashed_border.dart';
import '../state_management/create_property_cubit.dart';
import '../state_management/create_property_state.dart';
import '../widgets/header_widget.dart';

class ProofOfOwnershipPage extends StatefulWidget {
  final bool isEdit;
  const ProofOfOwnershipPage({super.key, this.isEdit = false});

  @override
  State<ProofOfOwnershipPage> createState() => _ProofOfOwnershipPageState();
}

class _ProofOfOwnershipPageState extends State<ProofOfOwnershipPage> {
  final List<String> _photos = [];
  String? _documentTypeError;
  String? _uploadError;
  static const int _maxPhotos = 5;
  final FilePickerService _filePickerService = FilePickerService();

  final ImagePickerService _imagePickerService = ImagePickerService();
  String? _selectedDocumentType;

  static const Map<String, String> _documentTypes = {
    'title_deed': AppStrings.titleDeed,
    'sale_contract': AppStrings.saleContract,
    'inheritance_deed': AppStrings.inheritanceDeed,
    'power_of_attorney': AppStrings.powerOfAttorney,
    'municipal_record': AppStrings.municipalRecord,
  };

  @override
  void initState() {
    super.initState();
    final state = context.read<CreatePropertyCubit>().state;
    if (state.proofPhotos.isNotEmpty) {
      _photos.addAll(state.proofPhotos);
    }
    if (state.proofDocuments.isNotEmpty) {
      // Exclude files converted from proofPhotos to prevent UI duplication
      final nonPhotoFiles = state.proofDocuments
          .where((file) => !state.proofPhotos.contains(file.path))
          .toList();
      _files.addAll(nonPhotoFiles);
    }
    if (state.ownershipDocumentType.isNotEmpty) {
      _selectedDocumentType = state.ownershipDocumentType;
    }
  }

  Future<void> _pickImages() async {
    final remainingPhotos = _maxPhotos - _photos.length;

    if (remainingPhotos <= 0) return;

    try {
      final images = await _imagePickerService.pickImages(
        limit: remainingPhotos,
      );

      if (!mounted || images.isEmpty) return;

      setState(() {
        _photos.addAll(images);
        _uploadError = null;
      });
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  Future<void> _takePhoto() async {
    final remainingPhotos = _maxPhotos - _photos.length;

    if (remainingPhotos <= 0) return;

    try {
      final String? photoPath = await _imagePickerService.takePhoto();

      if (!mounted || photoPath == null) return;

      setState(() {
        _photos.add(photoPath);
        _uploadError = null;
      });
    } catch (e) {
      debugPrint('Image picker error: $e');
    }
  }

  final List<PlatformFile> _files = [];
  static const int _maxFiles = 5;

  Future<void> _pickFile() async {
    final remainingFiles = _maxFiles - _files.length;

    if (remainingFiles <= 0) return;

    try {
      final List<PlatformFile> selectedFiles = await _filePickerService
          .pickDocuments();

      if (!mounted || selectedFiles.isEmpty) return;

      // Automatically take only up to the remaining slots (first 5 files max)
      final filesToAdd = selectedFiles.take(remainingFiles).toList();

      if (selectedFiles.length > remainingFiles) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Only the first $remainingFiles file(s) were added. Maximum $_maxFiles files allowed.',
            ),
          ),
        );
      }

      setState(() {
        _files.addAll(filesToAdd);
        _uploadError = null;
      });
    } catch (e) {
      debugPrint('File picker error: $e');
    }
  }

  void _removeFile(int index) {
    setState(() {
      _files.removeAt(index);
    });
  }

  void _deletePhoto(String photo) {
    setState(() {
      _photos.remove(photo);
    });
  }

  Widget _buildPhotosGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 95,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _photos.length,
      itemBuilder: (context, index) {
        final photo = _photos[index];

        return photoItem(photo);
      },
    );
  }

  Widget photoItem(String photo) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            File(photo),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () => _deletePhoto(photo),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iconBg,
              ),
              child: Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: SvgPicture.asset(AppIcons.remove, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildDocumentTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.white40,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _documentTypeError != null
                  ? AppColors.error
                  : AppColors.photoBorder,
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDocumentType,
              isExpanded: true,
              borderRadius: BorderRadius.circular(12),
              hint: Text(
                AppStrings.selectDocumentType,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.white),
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.white,
              ),
              dropdownColor: AppColors.white,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
              selectedItemBuilder: (BuildContext context) {
                return _documentTypes.entries.map<Widget>((entry) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList();
              },
              items: _documentTypes.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDocumentType = value;
                  _documentTypeError = null;
                });
                if (value != null) {
                  context
                      .read<CreatePropertyCubit>()
                      .ownershipDocumentTypeChanged(
                        value,
                      );
                }
              },
            ),
          ),
        ),
        if (_documentTypeError != null) ...[
          const SizedBox(height: 6),
          Text(
            _documentTypeError!,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }

  Widget _buildFilesList() {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        itemBuilder: (_, index) {
          final file = _files[index];

          return fileItem(file, index);
        },
        separatorBuilder: (_, _) => SizedBox(height: 8),
        itemCount: _files.length,
      ),
    );
  }

  Widget fileItem(PlatformFile file, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SvgPicture.asset(AppIcons.uploadFile),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              file.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(color: AppColors.white),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              _removeFile(index);
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.iconBg,
              ),
              child: Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: SvgPicture.asset(AppIcons.remove, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePropertyCubit, CreatePropertyState>(
      listener: (context, state) {
        if (state.status == CreatePropertyStatus.step5Saved) {
          if (widget.isEdit) {
            context.pop();
          } else {
            context.push(RouteNames.reviewListingPage);
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(ImagePath.background, fit: BoxFit.cover),
            ),

            SafeArea(
              child: Column(
                children: [
                  HeaderWidget(
                    title: AppStrings.listYourPropertyPage5Title,
                    subTitle: AppStrings.listYourPropertyStep5,
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppStrings.uploadDocuments,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: AppColors.white),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '*',
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Text(
                                  AppStrings.documentType,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  '*',
                                  style: TextStyle(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildDocumentTypeDropdown(),

                            const SizedBox(height: 24),

                            // Upload area
                            GestureDetector(
                              onTap: () {
                                if (_files.length >= _maxFiles) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'You can only upload up to 5 documents.',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                _pickFile();
                              },
                              child: CustomPaint(
                                painter: DashedBorderPainter(
                                  color: AppColors.photoBorder,
                                  strokeWidth: 2,
                                  dashWidth: 6,
                                  dashSpace: 4,
                                  radius: 16,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    color: AppColors.addPhotoBg,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 58,
                                        height: 58,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          AppIcons.uploadFile,
                                        ),
                                      ),

                                      const SizedBox(height: 20),

                                      Text(
                                        AppStrings.taptpUpload,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: AppColors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),
                            Text(
                              AppStrings.uploadDescription,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: AppColors.white60),
                            ),

                            const SizedBox(height: 29),
                            Row(
                              children: [
                                Expanded(
                                  child: AppElevatedButton(
                                    text: AppStrings.takePhoto,
                                    onPressed: () => _takePhoto(),
                                    preIcon: SvgPicture.asset(AppIcons.camera),
                                    borderColor: AppColors.white,
                                    backgroundColor: AppColors.transparent,
                                    borderWidth: 1,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.white),
                                    enableBorder: true,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: AppElevatedButton(
                                    text: AppStrings.gallery,
                                    onPressed: () => _pickImages(),
                                    preIcon: SvgPicture.asset(
                                      AppIcons.addPhoto,
                                    ),
                                    borderColor: AppColors.white,
                                    backgroundColor: AppColors.transparent,
                                    borderWidth: 1,
                                    enableBorder: true,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.white),
                                  ),
                                ),
                              ],
                            ),
                            if (_uploadError != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                _uploadError!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.error),
                              ),
                            ],

                            const SizedBox(height: 35),
                            if (_photos.isNotEmpty) _buildPhotosGrid(),
                            if (_files.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              _buildFilesList(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  SubmitButtonWidget(
                    text: widget.isEdit
                        ? AppStrings.saveChanges
                        : AppStrings.continueText,
                    onPressed: () {
                      bool hasError = false;
                      if (_selectedDocumentType == null ||
                          _selectedDocumentType!.isEmpty) {
                        setState(() {
                          _documentTypeError =
                              AppStrings.pleaseSelectDocumentType;
                        });
                        hasError = true;
                      }

                      if (_photos.isEmpty && _files.isEmpty) {
                        setState(() {
                          _uploadError =
                              'Please upload at least one document or photo';
                        });
                        hasError = true;
                      }

                      if (hasError) return;

                      context.read<CreatePropertyCubit>().saveStep5(
                        proofPhotos: _photos,
                        proofDocuments: _files,
                        ownershipDocumentType: _selectedDocumentType!,
                      );
                    },
                  ),
                  const SizedBox(height: 33),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
