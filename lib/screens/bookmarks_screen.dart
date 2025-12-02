import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import '../models/book.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final List<Bookmark> _bookmarks = [
    Bookmark(
      id: '1',
      bookId: '1',
      bookTitle: 'The Great Gatsby',
      chapter: 'Chapter 7',
      page: 120,
      date: DateTime.now().subtract(const Duration(days: 1)),
      coverColor: DesignSystem.grey200,
    ),
    Bookmark(
      id: '2',
      bookId: '2',
      bookTitle: '1984',
      chapter: 'Part 1, Chapter 3',
      page: 45,
      date: DateTime.now().subtract(const Duration(days: 3)),
      coverColor: DesignSystem.grey300,
    ),
    Bookmark(
      id: '3',
      bookId: '1',
      bookTitle: 'The Great Gatsby',
      chapter: 'Chapter 3',
      page: 55,
      date: DateTime.now().subtract(const Duration(days: 5)),
      coverColor: DesignSystem.grey200,
    ),
  ];

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
            const MobileHeader(title: 'BOOKMARKS'),
            // Bookmarks List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                itemCount: _bookmarks.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: DesignSystem.spacingMD),
                itemBuilder: (context, index) {
                  final bookmark = _bookmarks[index];
                  return _buildBookmarkCard(bookmark);
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentItem: BottomNavItem.bookmarks,
        onItemSelected: (item) {
          if (item == BottomNavItem.home) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (item == BottomNavItem.highlights) {
            Navigator.of(context).pushReplacementNamed('/highlights');
          } else if (item == BottomNavItem.settings) {
            Navigator.of(context).pushReplacementNamed('/settings');
          }
        },
      ),
    );
  }

  Widget _buildBookmarkCard(Bookmark bookmark) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: BoxDecoration(
        color: DesignSystem.primaryWhite,
        border: DesignSystem.border,
        boxShadow: DesignSystem.shadowSmall,
      ),
      child: Row(
        children: [
          // Mini Cover
          Container(
            width: 48,
            height: 64,
            decoration: BoxDecoration(
              color: bookmark.coverColor ?? DesignSystem.grey200,
              border: DesignSystem.border,
            ),
            child: bookmark.coverImagePath != null
                ? Image.asset(bookmark.coverImagePath!, fit: BoxFit.cover)
                : const Icon(
                    Icons.menu_book,
                    size: DesignSystem.iconSizeLG,
                    color: DesignSystem.primaryBlack,
                  ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookmark.bookTitle,
                  style: DesignSystem.textBase.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                if (bookmark.chapter != null) ...[
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    bookmark.chapter!,
                    style: DesignSystem.textSM.copyWith(
                      fontWeight: FontWeight.w500,
                      color: DesignSystem.grey600,
                    ),
                  ),
                ],
                const SizedBox(height: DesignSystem.spacingXS),
                Row(
                  children: [
                    Text(
                      'PAGE ${bookmark.page}',
                      style: DesignSystem.textXS.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: DesignSystem.spacingSM),
                    Text(
                      '• ${_formatDate(bookmark.date)}',
                      style: DesignSystem.textXS.copyWith(
                        fontWeight: FontWeight.w500,
                        color: DesignSystem.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
