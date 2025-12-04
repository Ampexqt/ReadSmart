import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';

enum BottomNavItem { home, bookmarks, highlights, settings }

class BottomNav extends StatelessWidget {
  final BottomNavItem currentItem;
  final Function(BottomNavItem) onItemSelected;

  const BottomNav({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.cardColor(isDark),
        border: Border(top: DesignSystem.themeBorderSide(isDark)),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingSM,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              icon: Icons.home,
              label: 'HOME',
              item: BottomNavItem.home,
            ),
            _buildNavItem(
              context,
              icon: Icons.bookmark,
              label: 'BOOKMARKS',
              item: BottomNavItem.bookmarks,
            ),
            _buildNavItem(
              context,
              icon: Icons.format_quote,
              label: 'HIGHLIGHTS',
              item: BottomNavItem.highlights,
            ),
            _buildNavItem(
              context,
              icon: Icons.settings,
              label: 'SETTINGS',
              item: BottomNavItem.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required BottomNavItem item,
  }) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;
    final isActive = currentItem == item;

    return GestureDetector(
      onTap: () => onItemSelected(item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive
                  ? DesignSystem.textColor(isDark)
                  : DesignSystem.cardColor(isDark),
              border: DesignSystem.themeBorder(isDark),
            ),
            child: Icon(
              icon,
              size: DesignSystem.iconSizeMD,
              color: isActive
                  ? DesignSystem.backgroundColor(isDark)
                  : DesignSystem.textColor(isDark),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            label,
            style: DesignSystem.textXS.copyWith(
              fontWeight: FontWeight.w700,
              color: DesignSystem.textColor(isDark),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
