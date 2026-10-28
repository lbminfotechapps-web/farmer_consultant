import 'package:flutter/material.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';

class QuickAccessItem {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const QuickAccessItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onTap,
  });
}

class DashboardMenu extends StatelessWidget {
  final VoidCallback? onWeatherTap;
  final VoidCallback? onMyPlotsTap;
  final VoidCallback? onQuickReferenceTap;
  final VoidCallback? onNearDealersTap;
  final VoidCallback? onContactUsTap;
  final VoidCallback? onImportantLinksTap;
  final VoidCallback? onSocialMediaTap;
  final VoidCallback? onAboutUsTap;
  final VoidCallback? onCropAdviceTap;
  final VoidCallback? onGalleryTap;

  const DashboardMenu({
    super.key,
    this.onWeatherTap,
    this.onMyPlotsTap,
    this.onQuickReferenceTap,
    this.onNearDealersTap,
    this.onContactUsTap,
    this.onImportantLinksTap,
    this.onSocialMediaTap,
    this.onAboutUsTap,
    this.onCropAdviceTap,
    this.onGalleryTap,
  });

  List<QuickAccessItem> _getMenus(AppLocalizations strings) {
    return [
      QuickAccessItem(
        title: strings.myPlots,
        icon: Icons.grass_rounded,
        iconColor: const Color(0xFF15803D),
        backgroundColor: const Color(0xFFDCFCE7),
        onTap: onMyPlotsTap,
      ),
      QuickAccessItem(
        title: strings.nearDealers,
        icon: Icons.storefront_outlined,
        iconColor: const Color(0xFFEA580C),
        backgroundColor: const Color(0xFFFFEDD5),
        onTap: onNearDealersTap,
      ),
      QuickAccessItem(
        title: strings.quickReference,
        icon: Icons.menu_book_rounded,
        iconColor: const Color(0xFF7C3AED),
        backgroundColor: const Color(0xFFF3E8FF),
        onTap: onQuickReferenceTap,
      ),
      QuickAccessItem(
        title: strings.weather,
        icon: Icons.cloud_outlined,
        iconColor: const Color(0xFF0284C7),
        backgroundColor: const Color(0xFFE0F2FE),
        onTap: onWeatherTap,
      ),
      QuickAccessItem(
        title: strings.importantLinks,
        icon: Icons.link_rounded,
        iconColor: const Color(0xFF4F46E5),
        backgroundColor: const Color(0xFFE0E7FF),
        onTap: onImportantLinksTap,
      ),
      QuickAccessItem(
        title: strings.cropAdvice,
        icon: Icons.eco_outlined,
        iconColor: const Color(0xFF16A34A),
        backgroundColor: const Color(0xFFDCFCE7),
        onTap: onCropAdviceTap,
      ),
      QuickAccessItem(
        title: strings.gallery,
        icon: Icons.photo_library_outlined,
        iconColor: const Color(0xFF9333EA),
        backgroundColor: const Color(0xFFF3E8FF),
        onTap: onGalleryTap,
      ),
      QuickAccessItem(
        title: strings.socialMedia,
        icon: Icons.share_outlined,
        iconColor: const Color(0xFFDB2777),
        backgroundColor: const Color(0xFFFCE7F3),
        onTap: onSocialMediaTap,
      ),
      QuickAccessItem(
        title: strings.aboutUs,
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF475569),
        backgroundColor: const Color(0xFFF1F5F9),
        onTap: onAboutUsTap,
      ),
      QuickAccessItem(
        title: strings.contactUs,
        icon: Icons.support_agent_rounded,
        iconColor: const Color(0xFF0891B2),
        backgroundColor: const Color(0xFFCFFAFE),
        onTap: onContactUsTap,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final menus = _getMenus(strings);
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.grid_view_rounded, color: colors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                strings.quickAccess,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.04),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var row = 0; row < 3; row++) ...[
                if (row > 0)
                  Divider(
                    height: 1,
                    indent: 12,
                    endIndent: 12,
                    color: colors.outlineVariant.withValues(alpha: 0.35),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var column = 0; column < 4; column++)
                      Expanded(
                        child: row * 4 + column < menus.length
                            ? QuickAccessMenuItem(menu: menus[row * 4 + column])
                            : const SizedBox.shrink(),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class QuickAccessMenuItem extends StatelessWidget {
  final QuickAccessItem menu;

  const QuickAccessMenuItem({super.key, required this.menu});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: menu.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(menu.backgroundColor, colors.surface, 0.4)!,
                      menu.backgroundColor,
                    ],
                  ),
                  border: Border.all(
                    color: menu.iconColor.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(menu.icon, size: 25, color: menu.iconColor),
              ),
              const SizedBox(height: 9),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 30 * MediaQuery.textScalerOf(context).scale(1),
                ),
                child: Text(
                  menu.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.3,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
