import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/config/routes/routes_names.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/constant/app_icons.dart';
import 'package:mobile/core/constant/images_path.dart';
import 'package:mobile/core/constant/strings.dart';
import '../state_management/create_property_cubit.dart';
import '../state_management/create_property_state.dart';
import '../widgets/header_widget.dart';
import '../widgets/submit_button_widget.dart';

class ReviewListingPage extends StatefulWidget {
  const ReviewListingPage({super.key});

  @override
  State<ReviewListingPage> createState() => _ReviewListingPageState();
}

class _ReviewListingPageState extends State<ReviewListingPage> {
  final List<String> _photos = [];

  @override
  void initState() {
    super.initState();
    final state = context.read<CreatePropertyCubit>().state;
    if (state.photos.isNotEmpty) {
      _photos.addAll(state.photos);
    }
  }

  void _deleteImage(String image) {
    setState(() {
      _photos.remove(image);
    });
    context.read<CreatePropertyCubit>().photosChanged(List.from(_photos));
  }

  void _submitListing(BuildContext context) {
    context.read<CreatePropertyCubit>().createProperty();
  }

  String _formatLocation(CreatePropertyState state) {
    final parts = [state.city, state.district]
        .where((s) => s.trim().isNotEmpty)
        .toList();
    if (parts.isEmpty) return '-';
    return parts.join(', ');
  }

  String _formatArea(CreatePropertyState state) {
    if (state.areaSqm == null) return '-';
    final areaVal = state.areaSqm! % 1 == 0
        ? state.areaSqm!.toInt().toString()
        : state.areaSqm!.toString();
    return '$areaVal m²';
  }

  String _formatPrice(CreatePropertyState state) {
    if (state.price == null) return '-';
    final priceVal = state.price! % 1 == 0
        ? state.price!.toInt().toString()
        : state.price!.toString();
    final currency =
        state.priceCurrency.isNotEmpty ? ' ${state.priceCurrency}' : '';

    // Prohibited if listing_type is sale
    if (state.listingType.toLowerCase() == 'sale') {
      return '$priceVal$currency';
    }

    // Required for rent: per_month, per_year, per_week, per_day, per_hour
    const unitMap = {
      'per_month': '/ month',
      'per_year': '/ year',
      'per_week': '/ week',
      'per_day': '/ day',
      'per_hour': '/ hour',
    };

    final unit = unitMap[state.priceUnit.toLowerCase()] ??
        (state.priceUnit.isNotEmpty && state.priceUnit.toLowerCase() != 'total'
            ? ' / ${state.priceUnit.replaceAll('_', ' ')}'
            : '');
    return '$priceVal$currency$unit';
  }

  String _formatListingType(String type) {
    if (type.toLowerCase() == 'sale') return 'For Sale';
    if (type.toLowerCase() == 'rent') return 'For Rent';
    return type.isNotEmpty ? type : '-';
  }

  String _formatPropertyType(String type) {
    const typeMap = {
      'apartment': 'Apartment',
      'house': 'House',
      'villa': 'Villa',
      'land': 'Land',
      'office': 'Office',
      'shop': 'Shop',
      'warehouse': 'Warehouse',
      'building': 'Building',
      'farm': 'Farm',
    };
    return typeMap[type.toLowerCase()] ??
        (type.isNotEmpty
            ? '${type[0].toUpperCase()}${type.substring(1)}'
            : '-');
  }

  String _formatFeatureName(String feature) {
    const featureMap = {
      'elevator': 'Elevator',
      'parking': 'Parking',
      'garden': 'Garden',
      'water': 'Water',
      'electricity': 'Electricity',
      'internet': 'Internet',
    };
    return featureMap[feature.toLowerCase()] ??
        feature
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) =>
                w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreatePropertyCubit, CreatePropertyState>(
      listener: (context, state) {
        if (state.status == CreatePropertyStatus.created) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Listing submitted successfully')),
          );
          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        if (state.status == CreatePropertyStatus.createError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Failed to submit listing'),
            ),
          );
        }

        if (state.status == CreatePropertyStatus.validationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Invalid data'),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
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
                      title: AppStrings.listYourPropertyPage6Title,
                      subTitle: AppStrings.listYourPropertyStep6,
                    ),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // =========================================
                            // Photos Section
                            // =========================================
                            if (_photos.isNotEmpty) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Text(
                                  AppStrings.photos,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                height: 140,
                                child: ListView.separated(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _photos.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(width: 14),
                                  itemBuilder: (context, index) {
                                    final photo = _photos[index];
                                    return _propertyImage(photo);
                                  },
                                ),
                              ),
                              const SizedBox(height: 28),
                            ],

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // =========================================
                                  // Basic Details
                                  // =========================================
                                  _sectionTitle(
                                    context: context,
                                    title: AppStrings.basicDetailsTitle,
                                    onEdit: () {
                                      context.push(
                                          RouteNames.propertyLocationScreen);
                                    },
                                  ),

                                  const SizedBox(height: 10),

                                  _detailRow(
                                    context,
                                    AppStrings.listingType,
                                    _formatListingType(state.listingType),
                                  ),
                                  _divider(),
                                  _detailRow(
                                    context,
                                    AppStrings.propertyType,
                                    _formatPropertyType(state.type),
                                  ),
                                  _divider(),
                                  _detailRow(
                                    context,
                                    AppStrings.location,
                                    _formatLocation(state),
                                  ),
                                  _divider(),
                                  _detailRow(
                                    context,
                                    AppStrings.area,
                                    _formatArea(state),
                                  ),
                                  _divider(),
                                  _detailRow(
                                    context,
                                    AppStrings.price,
                                    _formatPrice(state),
                                  ),
                                  _divider(),
                                  _detailRow(
                                    context,
                                    AppStrings.rooms,
                                    state.rooms != null
                                        ? state.rooms.toString()
                                        : '-',
                                  ),
                                  _divider(),
                                  _detailRow(
                                    context,
                                    AppStrings.bathrooms,
                                    state.bathrooms != null
                                        ? state.bathrooms.toString()
                                        : '-',
                                  ),
                                  if (state.floorNumber != null &&
                                      state.floorNumber! > 0) ...[
                                    _divider(),
                                    _detailRow(
                                      context,
                                      'Floor',
                                      state.floorNumber.toString(),
                                    ),
                                  ],

                                  const SizedBox(height: 28),

                                  // =========================================
                                  // Features
                                  // =========================================
                                  _sectionTitle(
                                    context: context,
                                    title: AppStrings.features,
                                    onEdit: () {
                                       context.push(
                                          RouteNames.listPropertyFeaturesScreen);
                                  
                                    },
                                  ),

                                  const SizedBox(height: 14),

                                  _buildFeaturesGrid(context, state.features),

                                  const SizedBox(height: 28),

                                  // =========================================
                                  // Description
                                  // =========================================
                                  _sectionTitle(
                                    context: context,
                                    title: AppStrings.description,
                                    onEdit: () {
                                       context.push(
                                          RouteNames.listPropertyFeaturesScreen);
                                  
                                    },
                                  ),

                                  const SizedBox(height: 14),

                                  Text(
                                    state.description.isNotEmpty
                                        ? state.description
                                        : '-',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.white70,
                                          fontSize: 15,
                                          height: 1.5,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),

                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SubmitButtonWidget(
                      onPressed: () {
                        if (!state.isLoading) {
                          _submitListing(context);
                        }
                      },
                    ),
                    const SizedBox(height: 33),
                  ],
                ),
              ),

              if (state.isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  // =============================================================
  Widget _propertyImage(String image) {
    final file = File(image);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: 210,
            height: 140,
            child: file.existsSync()
                ? Image.file(
                    file,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  )
                : Image.asset(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imagePlaceholder(),
                  ),
          ),
        ),

        Positioned(
          top: 6,
          right: 6,
          child: GestureDetector(
            onTap: () => _deleteImage(image),
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

  Widget _imagePlaceholder() {
    return Container(
      color: AppColors.cardBorder,
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: AppColors.white70),
      ),
    );
  }

  // =============================================================
  Widget _sectionTitle({
    required BuildContext context,
    required String title,
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        GestureDetector(
          onTap: onEdit,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AppIcons.edit, width: 16, height: 16),
              const SizedBox(width: 5),
              Text(
                AppStrings.edit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.white70,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =============================================================
  Widget _detailRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white70,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  Widget _divider() {
    return Container(height: 1, color: AppColors.cardBorder);
  }

  // =============================================================
  Widget _buildFeaturesGrid(BuildContext context, List<String> features) {
    if (features.isEmpty) {
      return Text(
        '-',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.white70,
              fontSize: 15,
            ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 16,
        mainAxisExtent: 22,
      ),
      itemBuilder: (context, index) {
        return Text(
          _formatFeatureName(features[index]),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
