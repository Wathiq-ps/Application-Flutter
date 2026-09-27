import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/constant/strings.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({
    super.key,
    required this.widthScale,
    required this.userName,
    this.fontSize = 16,
    this.color,
    this.maxLines = 1,
  });
  final double widthScale;
  final String userName;
  final double fontSize;
  final Color? color;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final String name = userName.trim();

    return Text(
      name.isEmpty ? AppStrings.hello : '${AppStrings.hello}, $name',
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color ?? AppColors.textPrimary,
        fontSize: fontSize * widthScale,
        fontWeight: FontWeight.w500,
        height: 16 / 16,
        letterSpacing: 0.24,
      ),
    );
  }
}