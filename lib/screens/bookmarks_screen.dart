import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final BookStorageService _storageService = BookStorageService();
  List<Bookmark> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    final bookmarks = await _storageService.loadBookmarks();
    // Sort by date, newest first
    bookmarks.sort((a, b) => b.date.compareTo(a.date));
    setState(() {
      _bookmarks = bookmarks;
      _isLoading = false;
    });
  }

  Future<void> _deleteBookmark(String bookmarkId) async {
    await _storageService.deleteBookmark(bookmarkId);
    _loadBookmarks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark deleted'),
          duration: Duration(seconds: 2),
          backgroundColor: DesignSystem.primaryBlack,
        ),
      );
    }
  }

  Future<void> _openBookmark(Bookmark bookmark) async {
    // Load the book and navigate to the bookmarked chapter
    final books = await _storageService.loadBooks();
    final book = books.firstWhere(
      (b) => b.id == bookmark.bookId,
      orElse: () => Book(
        id: bookmark.bookId,
        title: bookmark.bookTitle,
        author: 'Unknown',
      ),
    );

    if (mounted) {
      // Navigate to reader with the book and chapter info
      Navigator.of(context).pushNamed(
        '/reader',
        arguments: {'book': book, 'chapterIndex': bookmark.page},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: DesignSystem.backgroundColor(isDark),
      body: Container(
        constraints: const BoxConstraints(maxWidth: DesignSystem.maxWidth),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > DesignSystem.maxWidth
              ? (MediaQuery.of(context).size.width - DesignSystem.maxWidth) / 2
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
            const MobileHeader(title: 'BOOKMARKS'),
            // Bookmarks List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: DesignSystem.primaryBlack,
                      ),
                    )
                  : _bookmarks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.bookmark_border,
                            size: 64,
                            color: DesignSystem.grey400,
                          ),
                          const SizedBox(height: DesignSystem.spacingMD),
                          Text(
                            'NO BOOKMARKS YET',
                            style: DesignSystem.textLG.copyWith(
                              fontWeight: FontWeight.w900,
                              color: DesignSystem.grey600,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacingSM),
                          Text(
                            'Bookmark chapters while reading\nto save your progress',
                            textAlign: TextAlign.center,
                            style: DesignSystem.textBase.copyWith(
                              color: DesignSystem.grey600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
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
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Dismissible(
      key: Key(bookmark.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: DesignSystem.spacingLG),
        decoration: BoxDecoration(
          color: Colors.red,
          border: DesignSystem.themeBorder(isDark),
        ),
        child: const Icon(
          Icons.delete,
          color: DesignSystem.primaryWhite,
          size: DesignSystem.iconSizeLG,
        ),
      ),
      onDismissed: (direction) {
        _deleteBookmark(bookmark.id);
      },
      child: GestureDetector(
        onTap: () => _openBookmark(bookmark),
        child: Container(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          decoration: BoxDecoration(
            color: DesignSystem.cardColor(isDark),
            border: DesignSystem.themeBorder(isDark),
            boxShadow: DesignSystem.themeShadowSmall(isDark),
          ),
          child: Row(
            children: [
              // Mini Cover
              Container(
                width: 48,
                height: 64,
                decoration: BoxDecoration(
                  color: bookmark.coverColor ?? DesignSystem.grey200,
                  border: DesignSystem.themeBorder(isDark),
                ),
                child: bookmark.coverImagePath != null
                    ? Image.asset(bookmark.coverImagePath!, fit: BoxFit.cover)
                    : Icon(
                        Icons.menu_book,
                        size: DesignSystem.iconSizeLG,
                        color: isDark
                            ? DesignSystem.grey600
                            : DesignSystem.primaryBlack,
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
                        color: DesignSystem.textColor(isDark),
                      ),
                    ),
                    if (bookmark.chapter != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        bookmark.chapter!,
                        style: DesignSystem.textSM.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? DesignSystem.grey500
                              : DesignSystem.grey600,
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
                            color: DesignSystem.textColor(isDark),
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingSM),
                        Text(
                          '• ${_formatDate(bookmark.date)}',
                          style: DesignSystem.textXS.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? DesignSystem.grey500
                                : DesignSystem.grey600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon to indicate it's tappable
              Icon(
                Icons.chevron_right,
                color: isDark ? DesignSystem.grey500 : DesignSystem.grey600,
                size: DesignSystem.iconSizeLG,
              ),
            ],
          ),
        ),
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
