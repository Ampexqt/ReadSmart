import 'package:flutter/material.dart';
import '../theme/design_system.dart';

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
    return Container(
      decoration: const BoxDecoration(
        color: DesignSystem.primaryWhite,
        border: Border(top: DesignSystem.borderSide),
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
              icon: Icons.home,
              label: 'HOME',
              item: BottomNavItem.home,
            ),
            _buildNavItem(
              icon: Icons.bookmark,
              label: 'BOOKMARKS',
              item: BottomNavItem.bookmarks,
            ),
            _buildNavItem(
              icon: Icons.format_quote,
              label: 'HIGHLIGHTS',
              item: BottomNavItem.highlights,
            ),
            _buildNavItem(
              icon: Icons.settings,
              label: 'SETTINGS',
              item: BottomNavItem.settings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required BottomNavItem item,
  }) {
    final isActive = currentItem == item;
    return GestureDetector(
      onTap: () => onItemSelected(item),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive
                  ? DesignSystem.primaryBlack
                  : DesignSystem.primaryWhite,
              border: DesignSystem.border,
            ),
            child: Icon(
              icon,
              size: DesignSystem.iconSizeMD,
              color: isActive
                  ? DesignSystem.primaryWhite
                  : DesignSystem.primaryBlack,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            label,
            style: DesignSystem.textXS.copyWith(
              fontWeight: FontWeight.w700,
              color: DesignSystem.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }
}
