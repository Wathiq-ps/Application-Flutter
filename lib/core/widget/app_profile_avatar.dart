import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/theme/app_colors.dart';
import '../constant/app_icons.dart';



class AppProfileAvatar extends StatelessWidget {
  const AppProfileAvatar({
    super.key,
    required this.widthScale,
    this.size = 36,
    this.borderRadius,
    this.scaleRadius = true,
    this.imageFile,
    this.imageUrl,
    this.imageAsset,
    this.initialsSource,
    this.showInitialsFallback = false,
    this.backgroundColor,
    this.placeholderBackgroundColor,
    this.initialsColor,
    this.placeholderIcon = AppIcons.person,
    this.placeholderIconRatio = 0.55,
    this.borderColor,
    this.borderWidth = 0,
    this.showShadow = true,
    this.onTap,
  });


  final double widthScale;
  final double size;
  final double? borderRadius;
  final bool scaleRadius;
  final File? imageFile;
  final String? imageUrl;
  final String? imageAsset;
  final String? initialsSource;
  final bool showInitialsFallback;
  final Color? backgroundColor;
  final Color? placeholderBackgroundColor;
  final Color? initialsColor;
  final String placeholderIcon;
  final double placeholderIconRatio;
  final Color? borderColor;
  final double borderWidth;
  final bool showShadow;
  final VoidCallback? onTap;

  bool get _hasImage =>
      imageFile != null ||
          (imageUrl != null && imageUrl!.trim().isNotEmpty) ||
          (imageAsset != null && imageAsset!.trim().isNotEmpty);

  bool get _hasInitials =>
      showInitialsFallback &&
          initialsSource != null &&
          initialsSource!.trim().isNotEmpty;

  bool get _isCircle => borderRadius == null;

  double get _dimension => size * widthScale;

  double get _resolvedRadius {
    final double radius = borderRadius ?? 0;
    return scaleRadius ? radius * widthScale : radius;
  }

  BorderRadius? get _shapeRadius =>
      _isCircle ? null : BorderRadius.circular(_resolvedRadius);

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground = _hasImage || _hasInitials
        ? (backgroundColor ?? AppColors.primary)
        : (placeholderBackgroundColor ?? backgroundColor ?? AppColors.white);

    final Widget avatar = Container(
      width: _dimension,
      height: _dimension,
      decoration: BoxDecoration(
        color: resolvedBackground,
        shape: _isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: _shapeRadius,
        border: borderWidth > 0
            ? Border.all(
          color: borderColor ?? AppColors.primary,
          width: borderWidth * widthScale,
        )
            : null,
        boxShadow: showShadow
            ? [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 4 * widthScale,
          ),
        ]
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      child: _buildContent(),
    );

    if (onTap == null) return avatar;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: avatar,
    );
  }

  Widget _buildContent() {
    if (_hasImage) return _buildImage();
    if (_hasInitials) return _buildInitials();
    return _buildPlaceholderIcon();
  }

  Widget _buildImage() {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: _dimension,
        height: _dimension,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
      );
    }

    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: _dimension,
        height: _dimension,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: _dimension * 0.4,
              height: _dimension * 0.4,
              child: CircularProgressIndicator(
                strokeWidth: 1.5 * widthScale,
                color: AppColors.secondary,
              ),
            ),
          );
        },
      );
    }

    return Image.asset(
      imageAsset!,
      width: _dimension,
      height: _dimension,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
    );
  }

  Widget _buildInitials() {
    final String letter = initialsSource!.trim()[0].toUpperCase();
    return Text(
      letter,
      style: TextStyle(
        color: initialsColor ?? AppColors.secondary,
        fontSize: 12 * widthScale,
        fontWeight: FontWeight.w700,
        height: 16 / 12,
        letterSpacing: 0.24,
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    final double iconSize = _dimension * placeholderIconRatio;
    return Center(
      child: SvgPicture.asset(
        placeholderIcon,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
      ),
    );
  }
}