
import 'package:flutter/material.dart';

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

  List<QuickAccessItem> _getMenus() {
    return [
      QuickAccessItem(
        title: 'Weather',
        icon: Icons.cloud_outlined,
        iconColor: const Color(0xFF0284C7),
        backgroundColor: const Color(0xFFE0F2FE),
        onTap: onWeatherTap,
      ),
      QuickAccessItem(
        title: 'My Plots',
        icon: Icons.grass_rounded,
        iconColor: const Color(0xFF15803D),
        backgroundColor: const Color(0xFFDCFCE7),
        onTap: onMyPlotsTap,
      ),
      QuickAccessItem(
        title: 'Quick Reference',
        icon: Icons.menu_book_rounded,
        iconColor: const Color(0xFF7C3AED),
        backgroundColor: const Color(0xFFF3E8FF),
        onTap: onQuickReferenceTap,
      ),
      QuickAccessItem(
        title: 'Near Dealers',
        icon: Icons.storefront_outlined,
        iconColor: const Color(0xFFEA580C),
        backgroundColor: const Color(0xFFFFEDD5),
        onTap: onNearDealersTap,
      ),
      QuickAccessItem(
        title: 'Contact Us',
        icon: Icons.support_agent_rounded,
        iconColor: const Color(0xFF0891B2),
        backgroundColor: const Color(0xFFCFFAFE),
        onTap: onContactUsTap,
      ),
      QuickAccessItem(
        title: 'Important Links',
        icon: Icons.link_rounded,
        iconColor: const Color(0xFF4F46E5),
        backgroundColor: const Color(0xFFE0E7FF),
        onTap: onImportantLinksTap,
      ),
      QuickAccessItem(
        title: 'Social Media',
        icon: Icons.share_outlined,
        iconColor: const Color(0xFFDB2777),
        backgroundColor: const Color(0xFFFCE7F3),
        onTap: onSocialMediaTap,
      ),
      QuickAccessItem(
        title: 'About Us',
        icon: Icons.info_outline_rounded,
        iconColor: const Color(0xFF475569),
        backgroundColor: const Color(0xFFF1F5F9),
        onTap: onAboutUsTap,
      ),
      QuickAccessItem(
        title: 'Crop Advice',
        icon: Icons.eco_outlined,
        iconColor: const Color(0xFF16A34A),
        backgroundColor: const Color(0xFFDCFCE7),
        onTap: onCropAdviceTap,
      ),
      QuickAccessItem(
        title: 'Gallery',
        icon: Icons.photo_library_outlined,
        iconColor: const Color(0xFF9333EA),
        backgroundColor: const Color(0xFFF3E8FF),
        onTap: onGalleryTap,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final menus = _getMenus();
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                color: colors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quick Access',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                    ),
              ),
            ],
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                constraints.maxWidth < 300 ? 3 : 4;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: menus.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
                mainAxisExtent: 103,
              ),
              itemBuilder: (context, index) {
                return QuickAccessMenuItem(
                  menu: menus[index],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class QuickAccessMenuItem extends StatelessWidget {
  final QuickAccessItem menu;

  const QuickAccessMenuItem({
    super.key,
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: menu.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.outlineVariant.withValues(
                alpha: 0.6,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: menu.backgroundColor,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  menu.icon,
                  size: 23,
                  color: menu.iconColor,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                menu.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
