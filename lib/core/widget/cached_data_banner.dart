import 'package:flutter/material.dart';
import 'package:mobile/config/theme/app_colors.dart';

import '../constant/strings.dart';

class CachedDataBanner extends StatelessWidget {
  const CachedDataBanner({
    super.key,
    required this.widthScale,
    this.updatedAt,
    this.onRetry,
  });

  final double widthScale;
  final DateTime? updatedAt;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final ws = widthScale;
    final theme = Theme.of(context);
    final label = updatedAt == null
        ? AppStrings.showingSavedData
        : '${AppStrings.showingSavedData} · ${_ago(updatedAt!)}';

    return Container(
      margin: EdgeInsets.only(bottom: 13 * ws),
      padding: EdgeInsets.symmetric(horizontal: 14 * ws, vertical: 8 * ws),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14 * ws),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 18 * ws, color: AppColors.primary),
          SizedBox(width: 8 * ws),
          Expanded(
            child: Text(label,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 12.5 * ws)),
          ),
          if (onRetry != null)
            GestureDetector(
              onTap: onRetry,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4 * ws),
                child: Text(AppStrings.retry,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 13 * ws,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    )),
              ),
            ),
        ],
      ),
    );
  }

  static String _ago(DateTime t) {
    final d = DateTime.now().difference(t);
    if (d.inMinutes < 1) return 'just now';
    if (d.inHours < 1) return '${d.inMinutes} min ago';
    if (d.inDays < 1) return '${d.inHours} h ago';
    return '${d.inDays} d ago';
  }
}