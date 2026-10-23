import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:flutter/material.dart';

class DashboardQuickAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const DashboardQuickAction({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 51,
            height: 51,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.appTheme.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.appColors.primary,),
              boxShadow: [
                BoxShadow(
                  color: context.appColors.shadow.withValues(alpha: 0.035),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 28,
              color: iconColor ?? context.appColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: context.appTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}
