import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_text_styles.dart';
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';

class SocialMediaCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String link;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const SocialMediaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.link,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  Future<void> _share(BuildContext context) async {
    final strings = AppLocalizations.of(context)!;
    final box = context.findRenderObject() as RenderBox?;
    final origin = box != null && box.hasSize
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    try {
      await SharePlus.instance.share(
        ShareParams(
          subject: strings.socialShareSubject(title),
          text: strings.socialShareMessage(
            title,
            link.trim(),
            'https://play.google.com/store/apps/details?id=com.lbm.solufine',
          ),
          sharePositionOrigin: origin,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.unableToShare,
            style: AppTextStyles.body,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.borderColor),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.cardTitle.copyWith(
                        color: context.cardTextColor,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtitle,
                      style: AppTextStyles.cardSubtitle.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              Builder(
                builder: (shareContext) => IconButton(
                  tooltip: AppLocalizations.of(context)!.sharePlatform(title),
                  onPressed: () => _share(shareContext),
                  style: IconButton.styleFrom(
                    foregroundColor: iconColor,
                    backgroundColor: iconColor.withValues(alpha: 0.08),
                  ),
                  icon: const Icon(Icons.share_outlined, size: 20),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
