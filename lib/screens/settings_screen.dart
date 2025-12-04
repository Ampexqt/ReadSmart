import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import 'manage_books_modal.dart';
import '../services/book_storage_service.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BookStorageService _storageService = BookStorageService();
  bool _notifications = false; // Disabled by default
  String _fontSize = 'MEDIUM';
  int _bookCount = 0;

  @override
  void initState() {
    super.initState();
    _loadBookCount();
  }

  Future<void> _loadBookCount() async {
    final books = await _storageService.loadBooks();
    setState(() {
      _bookCount = books.length;
    });
  }

  void _showManageBooks() async {
    final hasChanges = await showDialog<bool>(
      context: context,
      builder: (context) => const ManageBooksModal(),
    );

    // Reload book count if changes were made
    if (hasChanges == true) {
      _loadBookCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final isDark = themeProvider.isDarkMode;

        return Scaffold(
          backgroundColor: DesignSystem.backgroundColor(isDark),
          body: Container(
            constraints: const BoxConstraints(maxWidth: DesignSystem.maxWidth),
            margin: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).size.width > DesignSystem.maxWidth
                  ? (MediaQuery.of(context).size.width -
                            DesignSystem.maxWidth) /
                        2
                  : 0,
            ),
            decoration: BoxDecoration(
              border: Border(
                left: DesignSystem.themeBorderSide(isDark),
                right: DesignSystem.themeBorderSide(isDark),
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
                            subtitle:
                                '$_bookCount ${_bookCount == 1 ? 'book' : 'books'}',
                            onTap: _showManageBooks,
                          ),
                        ]),
                        const SizedBox(height: DesignSystem.spacingLG),
                        _buildSection('APPEARANCE', [
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, _) {
                              return _buildSettingTile(
                                icon: Icons.dark_mode,
                                title: 'DARK MODE',
                                trailing: _buildToggle(
                                  themeProvider.isDarkMode,
                                  (value) {
                                    themeProvider.toggleTheme();
                                  },
                                ),
                              );
                            },
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
                              if (value) {
                                // Show coming soon message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'Coming Soon! Notifications feature is under development.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                    backgroundColor: DesignSystem.primaryBlack,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                // Keep it disabled
                                setState(() => _notifications = false);
                              } else {
                                setState(() => _notifications = value);
                              }
                            }),
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
      },
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: DesignSystem.textSM.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.05,
            color: DesignSystem.textColor(isDark),
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingMD),
        decoration: BoxDecoration(
          color: DesignSystem.cardColor(isDark),
          border: DesignSystem.themeBorder(isDark),
          boxShadow: DesignSystem.themeShadowSmall(isDark),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: DesignSystem.iconSizeLG,
              color: DesignSystem.textColor(isDark),
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
                      color: DesignSystem.textColor(isDark),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      subtitle,
                      style: DesignSystem.textSM.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? DesignSystem.grey500
                            : DesignSystem.grey600,
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return GestureDetector(
      onTap: () => setState(() => _fontSize = label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingSM),
        decoration: BoxDecoration(
          color: isActive
              ? DesignSystem.textColor(isDark)
              : DesignSystem.cardColor(isDark),
          border: DesignSystem.themeBorder(isDark),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: DesignSystem.textXS.copyWith(
            fontWeight: FontWeight.w700,
            color: isActive
                ? DesignSystem.backgroundColor(isDark)
                : DesignSystem.textColor(isDark),
          ),
        ),
      ),
    );
  }
}
