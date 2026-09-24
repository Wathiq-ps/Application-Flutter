import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/config/theme/app_colors.dart';
import 'package:mobile/features/home/presentation/widgets/promo_indicator.dart';
import '../../../../core/constant/app_icons.dart';
import '../../../../core/constant/strings.dart';
import '../../../../core/widget/app_button.dart';
import '../../../../core/widget/property_image.dart';
import 'package:mobile/features/property/domain/entities/property_entity.dart';

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
      _controller.nextPage(
        duration: _slideDuration,
        curve: Curves.easeInOutCubic,
      );
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

    return SizedBox(
      height: 190 * ws,
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, currentIdx, _) {
            return PageView.builder(
              controller: _controller,
              itemCount: _count > 1 ? null : 1,
              onPageChanged: (i) => _currentIndex.value = i % _count,
              itemBuilder: (context, index) {
                final property = widget.properties[index % _count];
                return AnimatedBuilder(
                  animation: _controller,
                  child: _PromoSlide(
                    property: property,
                    widthScale: ws,
                    count: _count,
                    currentIndex: currentIdx,
                    onTap: widget.onPropertyTap == null
                        ? null
                        : () => widget.onPropertyTap!(property),
                  ),
                  builder: (context, child) {
                    double delta = 0;
                    if (_controller.hasClients &&
                        _controller.position.haveDimensions) {
                      delta = ((_controller.page ?? index.toDouble()) - index)
                          .abs()
                          .clamp(0.0, 1.0);
                    }
                    return Opacity(
                      opacity: 1 - delta * 0.4,
                      child: Transform.scale(
                        scale: 1 - delta * 0.06,
                        child: child,
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PromoSlide extends StatelessWidget {
  const _PromoSlide({
    required this.property,
    required this.widthScale,
    required this.count,
    required this.currentIndex,
    this.onTap,
  });

  final PropertyEntity property;
  final double widthScale;
  final int count;
  final int currentIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24 * ws),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Backend image
            PropertyImage(path: property.coverPhoto, fit: BoxFit.cover),

            // Left-half shadow gradient
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.95),
                    AppColors.primary.withValues(alpha: 0.80),
                    AppColors.primary.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 34 * ws , bottom: 34 * ws ,left: 26 * ws,right: 26 * ws ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 20 * ws,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6 * ws),

                  Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.location,
                        width: 12 * ws,
                        height: 12 * ws,
                        colorFilter: ColorFilter.mode(
                          AppColors.white.withValues(alpha: 0.85),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 4 * ws),
                      Expanded(
                        child: Text(
                          property.locationLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color:   Color(0xffE7E8E9CC).withValues(alpha: 0.8),
                            fontSize: 12 * ws,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppElevatedButton(
                        text: AppStrings.viewDetails,
                        onPressed: onTap,
                        backgroundColor: AppColors.white,
                        width: 116 * ws,
                        height: 24 * ws,
                        borderRadius: 999 * ws,
                        textStyle: textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontSize: 13 * ws,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PromoIndicator(
                        count: count,
                        currentIndex: currentIndex,
                        widthScale: ws,
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

