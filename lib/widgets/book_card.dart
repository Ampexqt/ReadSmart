import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'brutal_card.dart';

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final double progress; // 0.0 to 1.0
  final String? coverImagePath;
  final Color? coverColor;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.title,
    required this.author,
    this.progress = 0.0,
    this.coverImagePath,
    this.coverColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return BrutalCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: coverColor ?? DesignSystem.grey200,
                border: Border(bottom: DesignSystem.themeBorderSide(isDark)),
              ),
              child: coverImagePath != null
                  ? (kIsWeb
                        ? Image.network(
                            coverImagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderIcon(isDark),
                          )
                        : Image.file(
                            File(coverImagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderIcon(isDark),
                          ))
                  : _buildPlaceholderIcon(isDark),
            ),
          ),
          // Content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignSystem.textBase.copyWith(
                      fontWeight: FontWeight.w700,
                      color: DesignSystem.textColor(isDark),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    author,
                    style: DesignSystem.textSM.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? DesignSystem.grey500
                          : DesignSystem.grey600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (progress > 0) ...[
                    const SizedBox(height: DesignSystem.spacingSM),
                    // Progress Bar
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDark
                            ? DesignSystem.grey700
                            : DesignSystem.grey200,
                        border: Border.all(
                          color: DesignSystem.borderColor(isDark),
                          width: DesignSystem.borderWidthSmall,
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(color: DesignSystem.textColor(isDark)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon(bool isDark) {
    return Center(
      child: Icon(
        Icons.menu_book,
        size: DesignSystem.iconSize2XL,
        color: isDark ? DesignSystem.grey600 : DesignSystem.primaryBlack,
      ),
    );
  }
}
