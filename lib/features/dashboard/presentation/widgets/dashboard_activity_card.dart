import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:flutter/material.dart';

class DashboardActivityCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? iconBackground;
  final VoidCallback onTap;
  final int? notificationCount;

  const DashboardActivityCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.iconBackground,
    this.notificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.cardBackgroundColor,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        borderRadius: BorderRadius.circular(13),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBackground ?? context.appColors.primary,
                  borderRadius: BorderRadius.circular(11),
         
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor ?? context.appColors.onPrimary,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.appTextStyles.cardTitle),
                    const SizedBox(height: 3),
                    Text(subtitle, style: context.appTextStyles.cardSubtitle),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (notificationCount != null && notificationCount! > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.appColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notificationCount! > 99 ? '99+' : '$notificationCount',
                    style: context.appTextStyles.badge,
                  ),
                )
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: context.appColors.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
