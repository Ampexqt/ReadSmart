import 'package:flutter/material.dart';
import '../theme/design_system.dart';
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
    return BrutalCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          AspectRatio(
            aspectRatio: DesignSystem.bookCoverAspectRatio,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: coverColor ?? DesignSystem.grey200,
                border: const Border(bottom: DesignSystem.borderSide),
              ),
              child: coverImagePath != null
                  ? (kIsWeb
                        ? Image.network(
                            coverImagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderIcon(),
                          )
                        : Image.file(
                            File(coverImagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholderIcon(),
                          ))
                  : _buildPlaceholderIcon(),
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: DesignSystem.textBase.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    author,
                    style: DesignSystem.textSM.copyWith(
                      fontWeight: FontWeight.w500,
                      color: DesignSystem.grey600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (progress > 0) ...[
                    const Spacer(),
                    // Progress Bar
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: DesignSystem.grey200,
                        border: DesignSystem.borderSmall,
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress,
                        child: Container(color: DesignSystem.primaryBlack),
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

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.menu_book,
        size: DesignSystem.iconSize2XL,
        color: DesignSystem.primaryBlack,
      ),
    );
  }
}
