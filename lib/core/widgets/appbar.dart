import 'package:farmer_consultant/core/secure_storage/secure_storage.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:farmer_consultant/core/theme/theme_picker_sheet.dart';
import 'package:flutter/material.dart';

class CommonDashboardAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final String userName;
  final String location;
  final String greeting;
  final bool showgreteting;
  final String? profileImage;
  final bool showProfile;
  final bool showNotification;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final bool showThemeButton;

  final bool showFilterButton;
  final bool isFilterActive;
  final VoidCallback? onFilterTap;

  const CommonDashboardAppBar({
    super.key,
    this.title,
    this.userName = '',
    this.location = '',
    this.greeting = 'Welcome,',
    this.showgreteting = true,
    this.profileImage,
    this.showProfile = true,
    this.showNotification = true,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onProfileTap,
    this.onBackTap,
    this.showThemeButton = true,
    this.backgroundColor,
    this.showFilterButton = false,
    this.isFilterActive = false,
    this.onFilterTap,
  });

  @override
  Size get preferredSize => Size.fromHeight(showProfile ? 92 : kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final appBarTheme = theme.appBarTheme;

    // ==========================================================
    // DYNAMIC APPBAR COLORS
    // ==========================================================

    final Color effectiveBackground =
        backgroundColor ?? appBarTheme.backgroundColor ?? colors.surface;

    final bool isDarkAppBar =
        ThemeData.estimateBrightnessForColor(effectiveBackground) ==
        Brightness.dark;

    // Respect the palette's AppBar foreground for normal themes.
    // If a custom background was provided, calculate contrast.
    final Color foreground = backgroundColor == null
        ? (appBarTheme.foregroundColor ??
              (isDarkAppBar ? Colors.white : Colors.black))
        : (isDarkAppBar ? Colors.white : Colors.black);

    final Color primaryColor = colors.primary;

    // ==========================================================
    // ICON COLORS
    // ==========================================================

    // Palette icon should contrast with the actual AppBar.
    final Color paletteIconColor = isDarkAppBar ? Colors.white : primaryColor;

    final Color paletteIconBackground = isDarkAppBar
        ? Colors.white.withValues(alpha: 0.16)
        : primaryColor.withValues(alpha: 0.12);

    // ==========================================================
    // PROFILE COLORS
    // ==========================================================

    final Color profileBackground = foreground.withValues(alpha: 0.12);

    final textStyles = context.appTextStyles;
    final titleStyle = textStyles.appBarTitle.copyWith(
      color: foreground,
      fontSize: 18,
    );
    final subtitleStyle = textStyles.appBarSubtitle.copyWith(
      color: foreground.withValues(alpha: 0.8),
    );

    if (!showProfile) {
      return AppBar(
        backgroundColor: effectiveBackground,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: true,
        leading: onBackTap == null
            ? null
            : IconButton(
                onPressed: onBackTap,
                icon: const Icon(Icons.arrow_back_ios_new),
              ),
        title: Text(title ?? '', style: titleStyle),
        actions: [
          if (showFilterButton)
            _filterButton(context, foreground, isFilterActive)
          else if (showNotification)
            _notificationButton(context, foreground, effectiveBackground),

          if (showThemeButton) ...[
            const SizedBox(width: 4),
            _AppBarCircleButton(
              icon: Icons.palette_outlined,
              tooltip: 'Change Theme',
              backgroundColor: paletteIconBackground,
              foregroundColor: paletteIconColor,
              onTap: () => ThemePickerSheet.show(context),
            ),
          ],

          const SizedBox(width: 8),
        ],
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 92,
      backgroundColor: effectiveBackground,
      foregroundColor: foreground,
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 23,
              backgroundColor: profileBackground,
              backgroundImage: profileImage != null && profileImage!.isNotEmpty
                  ? NetworkImage(profileImage!)
                  : null,
              child: profileImage == null || profileImage!.isEmpty
                  ? Icon(Icons.person, size: 27, color: foreground)
                  : null,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showgreteting) Text(greeting, style: subtitleStyle),
                const SizedBox(height: 2),
                _StoredFarmerName(fallbackName: userName, style: titleStyle),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12,
                      color: subtitleStyle.color,
                    ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: subtitleStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (showNotification)
          _notificationButton(context, foreground, effectiveBackground),

        if (showThemeButton) ...[
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _AppBarCircleButton(
              icon: Icons.palette_outlined,
              tooltip: 'Change Theme',
              backgroundColor: paletteIconBackground,
              foregroundColor: paletteIconColor,
              onTap: () {
                ThemePickerSheet.show(context);
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _filterButton(BuildContext context, Color foreground, bool isActive) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        tooltip: 'Filter schedules',
        onPressed: onFilterTap,
        style: IconButton.styleFrom(
          backgroundColor: isActive
              ? colorScheme.primary.withValues(alpha: 0.18)
              : foreground.withValues(alpha: 0.08),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              isActive ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
              size: 23,
              color: foreground,
            ),
            // if (isActive)
            //   Positioned(
            //     right: -2,
            //     top: -2,
            //     child: Container(
            //       width: 8,
            //       height: 8,
            //       decoration: BoxDecoration(
            //         color: colorScheme.error,
            //         shape: BoxShape.circle,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  Widget _notificationButton(
    BuildContext context,
    Color foreground,
    Color background,
  ) {
    return IconButton(
      onPressed: onNotificationTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_none_rounded, color: foreground, size: 27),
          if (notificationCount > 0)
            Positioned(
              right: 1,
              top: 1,
              child: Container(
                height: 9,
                width: 9,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                  border: Border.all(color: background, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StoredFarmerName extends StatefulWidget {
  final String fallbackName;
  final TextStyle style;

  const _StoredFarmerName({required this.fallbackName, required this.style});

  @override
  State<_StoredFarmerName> createState() => _StoredFarmerNameState();
}

class _StoredFarmerNameState extends State<_StoredFarmerName> {
  late final Future<String> _farmerName;

  @override
  void initState() {
    super.initState();
    _farmerName = SecureStorage.instance.getFarmerName();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _farmerName,
      builder: (context, snapshot) {
        final storedName = snapshot.data?.trim() ?? '';
        final fallbackName = widget.fallbackName.trim();
        return Text(
          storedName.isNotEmpty
              ? storedName
              : (fallbackName.isNotEmpty ? fallbackName : 'Farmer'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.style,
        );
      },
    );
  }
}

class _AppBarCircleButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _AppBarCircleButton({
    required this.icon,
    required this.tooltip,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: backgroundColor,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 38,
            height: 38,
            child: Center(child: Icon(icon, size: 20, color: foregroundColor)),
          ),
        ),
      ),
    );
  }
}
