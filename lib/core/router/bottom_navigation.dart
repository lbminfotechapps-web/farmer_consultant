import 'package:farmer_consultant/core/theme/app_theme_context.dart';
import 'package:farmer_consultant/core/theme/typography/app_typography_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:farmer_consultant/l10n/app_localizations.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const List<_NavigationItem> _items = [
    _NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    _NavigationItem(
      icon: Icons.grass_rounded,
      selectedIcon: Icons.grass_rounded,
      label: 'Plots',
    ),
    _NavigationItem(
      icon: Icons.inventory,
      selectedIcon: Icons.inventory_2_rounded,
      label: 'Products',
    ),
  ];

  void _onTabTapped(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = widget.navigationShell.currentIndex;
    final strings = AppLocalizations.of(context);
    final labels = [
      strings?.dashboard ?? 'Dashboard',
      strings?.plots ?? 'Plots',
      strings?.products ?? 'Products',
    ];
    final colors = context.appColors;
    final textStyles = context.appTextStyles;
    final navigationTheme = context.appThemeData.bottomNavigationBarTheme;
    final selectedColor = navigationTheme.selectedItemColor ?? colors.primary;
    final unselectedColor =
        navigationTheme.unselectedItemColor ?? context.secondaryTextColor;

    return PopScope<Object?>(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && widget.navigationShell.currentIndex != 0) {
          widget.navigationShell.goBranch(0);
        }
      },
      child: Scaffold(
        extendBody: true,
        backgroundColor: context.backgroundColor,

        body: widget.navigationShell,

        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 10),
          child: Container(
            constraints: const BoxConstraints(minHeight: 72),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: navigationTheme.backgroundColor ?? colors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_items.length, (index) {
                final item = _items[index];
                final isSelected = currentIndex == index;

                return Expanded(
                  child: InkWell(
                    onTap: () => _onTabTapped(index),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? context
                                      .appThemeData
                                      .navigationBarTheme
                                      .indicatorColor ??
                                  selectedColor.withValues(alpha: 0.10)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              isSelected ? item.selectedIcon : item.icon,
                              key: ValueKey(isSelected),
                              size: 24,
                              color: isSelected
                                  ? selectedColor
                                  : unselectedColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            labels[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: isSelected
                                ? textStyles.navigationLabelSelected.copyWith(
                                    color: selectedColor,
                                  )
                                : textStyles.navigationLabel.copyWith(
                                    color: unselectedColor,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}
