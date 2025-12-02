import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import 'manage_books_modal.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  String _fontSize = 'MEDIUM';

  void _showManageBooks() {
    showDialog(
      context: context,
      builder: (context) => const ManageBooksModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.primaryWhite,
      body: Container(
        constraints: const BoxConstraints(maxWidth: DesignSystem.maxWidth),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > DesignSystem.maxWidth
              ? (MediaQuery.of(context).size.width - DesignSystem.maxWidth) / 2
              : 0,
        ),
        decoration: const BoxDecoration(
          border: Border(
            left: DesignSystem.borderSide,
            right: DesignSystem.borderSide,
          ),
        ),
        child: Column(
          children: [
            // Header
            const MobileHeader(title: 'SETTINGS'),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('LIBRARY', [
                      _buildSettingTile(
                        icon: Icons.library_books,
                        title: 'MANAGE BOOKS',
                        subtitle: '4 books',
                        onTap: _showManageBooks,
                      ),
                    ]),
                    const SizedBox(height: DesignSystem.spacingLG),
                    _buildSection('APPEARANCE', [
                      _buildSettingTile(
                        icon: Icons.dark_mode,
                        title: 'DARK MODE',
                        trailing: _buildToggle(_darkMode, (value) {
                          setState(() => _darkMode = value);
                        }),
                      ),
                      const SizedBox(height: DesignSystem.spacingMD),
                      _buildFontSizeSelector(),
                    ]),
                    const SizedBox(height: DesignSystem.spacingLG),
                    _buildSection('READING', [
                      _buildSettingTile(
                        icon: Icons.font_download,
                        title: 'FONT SIZE',
                        subtitle: _fontSize,
                      ),
                    ]),
                    const SizedBox(height: DesignSystem.spacingLG),
                    _buildSection('NOTIFICATIONS', [
                      _buildSettingTile(
                        icon: Icons.notifications,
                        title: 'ENABLE NOTIFICATIONS',
                        trailing: _buildToggle(_notifications, (value) {
                          setState(() => _notifications = value);
                        }),
                      ),
                    ]),
                    const SizedBox(height: DesignSystem.spacingLG),
                    _buildSection('ACCOUNT', [
                      _buildSettingTile(
                        icon: Icons.person,
                        title: 'PROFILE',
                        onTap: () {
                          Navigator.of(context).pushNamed('/profile');
                        },
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentItem: BottomNavItem.settings,
        onItemSelected: (item) {
          if (item == BottomNavItem.home) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (item == BottomNavItem.bookmarks) {
            Navigator.of(context).pushReplacementNamed('/bookmarks');
          } else if (item == BottomNavItem.highlights) {
            Navigator.of(context).pushReplacementNamed('/highlights');
          }
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: DesignSystem.textSM.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingMD),
        decoration: BoxDecoration(
          color: DesignSystem.primaryWhite,
          border: DesignSystem.border,
          boxShadow: DesignSystem.shadowSmall,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: DesignSystem.iconSizeLG,
              color: DesignSystem.primaryBlack,
            ),
            const SizedBox(width: DesignSystem.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignSystem.textBase.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      subtitle,
                      style: DesignSystem.textSM.copyWith(
                        fontWeight: FontWeight.w500,
                        color: DesignSystem.grey600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 32,
        decoration: BoxDecoration(
          color: value ? DesignSystem.primaryBlack : DesignSystem.primaryWhite,
          border: DesignSystem.border,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 28 : 4,
              top: 4,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: DesignSystem.primaryWhite,
                  border: DesignSystem.borderSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    return Row(
      children: [
        Expanded(child: _buildFontSizeButton('SMALL', _fontSize == 'SMALL')),
        const SizedBox(width: DesignSystem.spacingSM),
        Expanded(child: _buildFontSizeButton('MEDIUM', _fontSize == 'MEDIUM')),
        const SizedBox(width: DesignSystem.spacingSM),
        Expanded(child: _buildFontSizeButton('LARGE', _fontSize == 'LARGE')),
      ],
    );
  }

  Widget _buildFontSizeButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _fontSize = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingSM),
        decoration: BoxDecoration(
          color: isActive
              ? DesignSystem.primaryBlack
              : DesignSystem.primaryWhite,
          border: DesignSystem.border,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: DesignSystem.textXS.copyWith(
            fontWeight: FontWeight.w700,
            color: isActive
                ? DesignSystem.primaryWhite
                : DesignSystem.primaryBlack,
          ),
        ),
      ),
    );
  }
}
