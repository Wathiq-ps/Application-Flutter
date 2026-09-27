import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/core/constant/app_icons.dart';
import '../../../../config/theme/app_colors.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.widthScale,
    required this.heightScale,
    this.subtitle,
    this.isDestructive = false,
    this.iconWidth,
    this.iconHeight,
  });

  final String icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final double widthScale;
  final double heightScale;
  final bool isDestructive;
  final double? iconWidth;
  final double? iconHeight;

  @override
  Widget build(BuildContext context) {
    final Color itemColor = isDestructive
        ? AppColors.destructiveText
        : AppColors.profileItemText;

    final Color iconColor = isDestructive
        ? AppColors.destructiveText
        : AppColors.primary;

    final bool hasSubtitle =
        subtitle != null && subtitle!.trim().isNotEmpty;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 72 * heightScale,
      ),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: AppColors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(
              12 * widthScale,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16 * widthScale,
                vertical: 12 * heightScale,
              ),
              child: Row(
                children: [
                  Container(
                    width: 40 * widthScale,
                    height: 40 * widthScale,
                    decoration: BoxDecoration(
                      color: isDestructive
                          ? AppColors.destructiveBg
                          : AppColors.profileItemIconBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      icon,
                      width: iconWidth ?? (20 * widthScale),
                      height: iconHeight ?? (20 * widthScale),
                      colorFilter: ColorFilter.mode(
                        iconColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16 * widthScale,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: itemColor,
                            fontSize: 16 * widthScale,
                            height: 24 / 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (hasSubtitle) ...[
                          SizedBox(height: 2 * heightScale),
                          Text(
                            subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                              color: isDestructive
                                  ? itemColor
                                  : AppColors.profileItemSubtitleText,
                              fontSize: 12 * widthScale,
                              height: 16 / 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!isDestructive)
                    SvgPicture.asset(
                      AppIcons.arrowRight,
                      width: 7.4 * widthScale,
                      height: 12 * heightScale,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}