import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../constant/images_path.dart';

class PropertyImage extends StatelessWidget {
  const PropertyImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String? path;
  final BoxFit fit;
  final double? width;
  final double? height;

  Widget _fallback() => Image.asset(
    ImagePath.villa,
    fit: fit,
    width: width,
    height: height,
  );

  @override
  Widget build(BuildContext context) {
    final value = path?.trim();

    if (value == null || value.isEmpty) return _fallback();

    if (value.startsWith('http')) {
      return Image.network(
        value,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : ColoredBox(color: AppColors.primary.withValues(alpha: 0.08)),
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }

    return Image.asset(
      value,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => _fallback(),
    );
  }
}