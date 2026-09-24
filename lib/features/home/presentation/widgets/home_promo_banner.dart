import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/core/utils/price_formatter.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';
import '../../../../core/constant/strings.dart';
import 'promo_indicator.dart';

class HomePromoBanner extends StatefulWidget {
  const HomePromoBanner({
    super.key,
    required this.properties,
    required this.widthScale,
    this.onPropertyTap,
    this.autoPlayInterval = const Duration(seconds: 5),
  }) : assert(properties.length > 0);

  final List<PropertyEntity> properties;
  final double widthScale;
  final ValueChanged<PropertyEntity>? onPropertyTap;
  final Duration autoPlayInterval;

  @override
  State<HomePromoBanner> createState() => _HomePromoBannerState();
}

class _HomePromoBannerState extends State<HomePromoBanner> {
  static const _slideDuration = Duration(milliseconds: 800);

  final PageController _controller = PageController();
  final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  Timer? _timer;
  bool _tickersEnabled = true;
  bool _userDragging = false;

  int get _count => widget.properties.length;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Pauses auto-play when this tab is hidden (IndexedStack disables tickers).
    _tickersEnabled = TickerMode.of(context);
    _tickersEnabled ? _startAutoPlay() : _stopAutoPlay();
  }

  @override
  void didUpdateWidget(covariant HomePromoBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.properties.length != _count) {
      _currentIndex.value = _currentIndex.value % _count;
      _startAutoPlay();
    }
  }

  @override
  void dispose() {
    _stopAutoPlay();
    _controller.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _stopAutoPlay();
    if (_count < 2 || !_tickersEnabled) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      if (!mounted || !_controller.hasClients) return;
      _controller.nextPage(duration: _slideDuration, curve: Curves.easeInOutCubic);
    });
  }

  void _stopAutoPlay() {
    _timer?.cancel();
    _timer = null;
  }

  bool _onScroll(ScrollNotification n) {
    if (n is ScrollStartNotification && n.dragDetails != null) {
      _userDragging = true;
      _stopAutoPlay();
    } else if (n is ScrollEndNotification && _userDragging) {
      _userDragging = false;
      _startAutoPlay();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ws = widget.widthScale;

    return Column(
      children: [
        SizedBox(
          height: 190 * ws,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: PageView.builder(
              controller: _controller,
              itemCount: _count > 1 ? null : 1, // null = endless loop
              onPageChanged: (i) => _currentIndex.value = i % _count,
              itemBuilder: (context, index) {
                final property = widget.properties[index % _count];
                return AnimatedBuilder(
                  animation: _controller,
                  child: _PromoSlide(
                    property: property,
                    widthScale: ws,
                    onTap: widget.onPropertyTap == null
                        ? null
                        : () => widget.onPropertyTap!(property),
                  ),
                  builder: (context, child) {
                    double delta = 0;
                    if (_controller.hasClients && _controller.position.haveDimensions) {
                      delta = ((_controller.page ?? index.toDouble()) - index)
                          .abs()
                          .clamp(0.0, 1.0);
                    }
                    return Opacity(
                      opacity: 1 - delta * 0.4,
                      child: Transform.scale(scale: 1 - delta * 0.06, child: child),
                    );
                  },
                );
              },
            ),
          ),
        ),
        SizedBox(height: 10 * ws),
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (_, index, __) =>
              PromoIndicator(count: _count, currentIndex: index, widthScale: ws),
        ),
      ],
    );
  }
}

class _PromoSlide extends StatelessWidget {
  const _PromoSlide({required this.property, required this.widthScale, this.onTap});

  final PropertyEntity property;
  final double widthScale;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    final textTheme = Theme.of(context).textTheme;
    final coverUrl = property.coverPhoto;
    final isRent = property.listingType == PropertyListingType.rent;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24 * ws),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
            ),
            if (coverUrl != null)
              Image.network(coverUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0.05),
                    AppColors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(18 * ws),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12 * ws, vertical: 5 * ws),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      isRent ? AppStrings.forRent : AppStrings.forSale,
                      style: textTheme.labelMedium?.copyWith(
                        color: AppColors.white,
                        fontSize: 12 * ws,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 20 * ws,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4 * ws),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 15 * ws, color: AppColors.white.withValues(alpha: 0.85)),
                      SizedBox(width: 4 * ws),
                      Expanded(
                        child: Text(
                          property.locationLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.white.withValues(alpha: 0.85),
                            fontSize: 13 * ws,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12 * ws),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          PriceFormatter.display(
                            price: property.price,
                            currency: property.priceCurrency,
                            unit: property.priceUnit,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.white,
                            fontSize: 16 * ws,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16 * ws, vertical: 8 * ws),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          AppStrings.viewDetails,
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.primary,
                            fontSize: 13 * ws,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}