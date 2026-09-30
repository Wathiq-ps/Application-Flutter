import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/images_path.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/extensions/media_query_extensions.dart';
import '../../../../core/widget/app_svg_button.dart';
import '../../../../core/widget/page_header.dart';
import '../../../property/domain/entities/property_entity.dart';

class ViewPropertyDetailsScreen extends StatefulWidget {
  final PropertyEntity property;

  const ViewPropertyDetailsScreen({
    super.key,
    required this.property,
  });

  @override
  State<ViewPropertyDetailsScreen> createState() =>
      _ViewPropertyDetailsScreenState();
}

class _ViewPropertyDetailsScreenState extends State<ViewPropertyDetailsScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<String> get _photoList => widget.property.photos;

  String _formatPrice(double price) {
    final isWhole = price.truncateToDouble() == price;
    final parts = (isWhole
            ? price.toInt().toString()
            : price.toStringAsFixed(2))
        .split('.');
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formattedInt =
        parts[0].replaceAllMapped(reg, (Match m) => '${m[1]},');
    return parts.length > 1 ? '$formattedInt.${parts[1]}' : formattedInt;
  }

  String _formatPriceUnit(String? unit) {
    if (unit == null || unit.trim().isEmpty) return '';
    final clean = unit.trim().toLowerCase();
    switch (clean) {
      case 'per_day':
      case 'day':
        return 'day';
      case 'per_week':
      case 'week':
        return 'week';
      case 'per_month':
      case 'month':
        return 'month';
      case 'per_year':
      case 'year':
        return 'year';
      case 'per_hour':
      case 'hour':
        return 'hr';
      default:
        final stripped = clean.replaceFirst(RegExp(r'^per_'), '');
        return stripped.isNotEmpty ? stripped : clean;
    }
  }

  Widget _buildImageItem(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          ImagePath.villa,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.asset(
        ImagePath.villa,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildFeatureChip(String iconAsset, String label, double widthScale) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14 * widthScale,
        vertical: 8 * widthScale,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFDCE5FA),
        borderRadius: BorderRadius.circular(10 * widthScale),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconAsset,
            width: 16 * widthScale,
            height: 16 * widthScale,
            colorFilter: const ColorFilter.mode(
              Color(0xFF00113A),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 6 * widthScale),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF00113A),
              fontSize: 13 * widthScale,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(double widthScale) {
    final List<Widget> chips = [];

    // 1. Rooms
    if (widget.property.rooms > 0) {
      final roomLabel =
          '${widget.property.rooms} ${widget.property.rooms == 1 ? 'Room' : 'Rooms'}';
      chips.add(_buildFeatureChip(AppIcons.bed, roomLabel, widthScale));
    }

    // 2. Bathrooms
    if (widget.property.bathrooms > 0) {
      final bathLabel =
          '${widget.property.bathrooms} ${widget.property.bathrooms == 1 ? 'Bath' : 'Baths'}';
      chips.add(_buildFeatureChip(AppIcons.bath, bathLabel, widthScale));
    }

    // 3. Area
    if (widget.property.areaSqm > 0) {
      final formattedArea = widget.property.areaSqm % 1 == 0
          ? widget.property.areaSqm.toInt().toString()
          : widget.property.areaSqm.toString();
      final areaLabel = '$formattedArea m²';
      chips.add(_buildFeatureChip(AppIcons.area, areaLabel, widthScale));
    }

    // 4. Features from list_property_features_screen.dart
    const featureDefinitions = [
      {
        'title': AppStrings.elevator,
        'icon': AppIcons.elevator,
        'value': 'elevator',
      },
      {
        'title': AppStrings.parking,
        'icon': AppIcons.parking,
        'value': 'parking',
      },
      {
        'title': AppStrings.furnished,
        'icon': AppIcons.furnished,
        'value': 'furnished',
      },
      {
        'title': AppStrings.garden,
        'icon': AppIcons.garden,
        'value': 'garden',
      },
      {
        'title': AppStrings.water,
        'icon': AppIcons.water,
        'value': 'water',
      },
      {
        'title': AppStrings.electricity,
        'icon': AppIcons.electricity,
        'value': 'electricity',
      },
      {
        'title': AppStrings.wifi,
        'icon': AppIcons.wifi,
        'value': 'wifi',
      },
    ];

    for (final feature in featureDefinitions) {
      final featureValue = feature['value']!.toLowerCase();
      final featureTitle = feature['title']!.toLowerCase();

      final isPresent = widget.property.features.any((f) {
            final lower = f.trim().toLowerCase();
            return lower == featureValue || lower == featureTitle;
          }) ||
          (featureValue == 'furnished' && widget.property.isFurnished);

      if (isPresent) {
        chips.add(
          _buildFeatureChip(
            feature['icon']!,
            feature['title']!,
            widthScale,
          ),
        );
      }
    }

  
    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8 * widthScale,
      runSpacing: 10 * widthScale,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    const double figmaWidth = 393.0;
    const double figmaHeight = 852.0;
    final double widthScale = context.screenWidth / figmaWidth;
    final double heightScale = context.screenHeight / figmaHeight;

    final photoList = _photoList;
    final photoCount = photoList.length;

    final titleText = widget.property.title;

    final locationText = widget.property.locationLabel;

    final descriptionText = widget.property.description;

    final priceFormatted = _formatPrice(widget.property.price);
    final currency = widget.property.priceCurrency;
    final formattedPriceUnit =
        _formatPriceUnit(widget.property.priceUnit);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Header / App Bar ──
            PageHeader(
              widthScale: widthScale,
              padding: EdgeInsets.symmetric(
                horizontal: 20 * widthScale,
                vertical: 8 * widthScale,
              ),
              left: AppSvgIconButton(
                widthScale: widthScale,
                icon: AppIcons.backArrowProp,
                iconWidth: 16,
                iconHeight: 16,
                onTap: () => Navigator.maybePop(context),
              ),
              center: Text(
                AppStrings.propertyDetails,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF00113A),
                  fontSize: 18 * widthScale,
                  fontWeight: FontWeight.w700,
                ),
              ),
              right: AppSvgIconButton(
                widthScale: widthScale,
                icon: _isFavorite
                    ? AppIcons.favouriteSelected
                    : AppIcons.favouriteUnselected,
                iconWidth: 20,
                iconHeight: 20,
                color: const Color(0xFF00113A),
                onTap: () => setState(() => _isFavorite = !_isFavorite),
              ),
              showCenter: true,
              showRight: true,
              expandCenter: true,
            ),

            // ── Scrollable Body ──
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20 * widthScale),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12 * heightScale),

                    // ── Photo Carousel Card ──
                    Container(
                      width: double.infinity,
                      height: 240 * widthScale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20 * widthScale),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          PageView.builder(
                            controller: _pageController,
                            itemCount: photoList.length,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            itemBuilder: (context, index) {
                              return _buildImageItem(photoList[index]);
                            },
                          ),

                          // 1/12 Indicator
                          Positioned(
                            top: 16 * widthScale,
                            left: 18 * widthScale,
                            child: Text(
                              '${_currentPage + 1}/$photoCount',
                              style: TextStyle(
                                color: const Color(0xFF00113A),
                                fontSize: 13 * widthScale,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          // Left and Right Navigation Arrows
                          Positioned(
                            bottom: 14 * widthScale,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (_currentPage > 0) {
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsets.all(6 * widthScale),
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 20 * widthScale,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16 * widthScale),
                                GestureDetector(
                                  onTap: () {
                                    if (_currentPage < photoList.length - 1) {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Padding(
                                    padding: EdgeInsets.all(6 * widthScale),
                                    child: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 20 * widthScale,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20 * widthScale),

                    // ── Title ──
                    Text(
                      titleText,
                      style: TextStyle(
                        color: const Color(0xFF00113A),
                        fontSize: 22 * widthScale,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),

                    SizedBox(height: 6 * widthScale),

                    // ── Location Row ──
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppIcons.location,
                          width: 14 * widthScale,
                          height: 14 * widthScale,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF00113A),
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 4 * widthScale),
                        Text(
                          locationText,
                          style: TextStyle(
                            color: const Color(0xFF00113A),
                            fontSize: 14 * widthScale,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 18 * widthScale),

                    // ── Feature Chips ──
                    _buildFeaturesGrid(widthScale),

                    SizedBox(height: 20 * widthScale),

                    // ── Description Section ──
                    Text(
                      AppStrings.description,
                      style: TextStyle(
                        color: const Color(0xFF00113A),
                        fontSize: 20 * widthScale,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 8 * widthScale),

                    Text(
                      descriptionText,
                      style: TextStyle(
                        color: const Color(0xFF00113A).withValues(alpha: 0.85),
                        fontSize: 14 * widthScale,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 22 * widthScale),

                    // ── Owner Profile Section ──
                    Row(
                      children: [
                        Container(
                          width: 48 * widthScale,
                          height: 48 * widthScale,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE9ECF2),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'M',
                            style: TextStyle(
                              color: const Color(0xFF00113A),
                              fontSize: 20 * widthScale,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        SizedBox(width: 14 * widthScale),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Manar Ayyoub',
                              style: TextStyle(
                                color: const Color(0xFF00113A),
                                fontSize: 18 * widthScale,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 3 * widthScale),
                            Text(
                              'Property Owner',
                              style: TextStyle(
                                color: const Color(0xFF64748B),
                                fontSize: 13 * widthScale,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 20 * widthScale),

                    // ── Divider ──
                    const Divider(
                      color: Color(0xFFD9DDE7),
                      thickness: 1,
                      height: 1,
                    ),

                    SizedBox(height: 18 * widthScale),

                    // ── Price Section ──
                    Text(
                      AppStrings.price,
                      style: TextStyle(
                        color: const Color(0xFF8C95A6),
                        fontSize: 13 * widthScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 4 * widthScale),

                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$priceFormatted $currency',
                            style: TextStyle(
                              color: const Color(0xFF00113A),
                              fontSize: 22 * widthScale,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          if (formattedPriceUnit.isNotEmpty)
                            TextSpan(
                              text: ' / $formattedPriceUnit',
                              style: TextStyle(
                                color: const Color(0xFF00113A),
                                fontSize: 16 * widthScale,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24 * widthScale),

                    // ── Send Requests Button ──
                    Container(
                      width: double.infinity,
                      height: 54 * widthScale,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color:
                                const Color(0xFF00113A).withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00113A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          'Send Requests',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16 * widthScale,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 24 * widthScale),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
