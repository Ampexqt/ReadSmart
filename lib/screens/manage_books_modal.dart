import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';
import '../widgets/brutal_modal.dart';
import '../widgets/brutal_button.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';
import 'edit_book_modal.dart';

class ManageBooksModal extends StatefulWidget {
  const ManageBooksModal({super.key});

  @override
  State<ManageBooksModal> createState() => _ManageBooksModalState();
}

class _ManageBooksModalState extends State<ManageBooksModal> {
  final BookStorageService _storageService = BookStorageService();
  List<Book> _books = [];
  bool _isLoading = true;
  bool _hasChanges = false; // Track if any books were deleted

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    final books = await _storageService.loadBooks();
    setState(() {
      _books = books;
      _isLoading = false;
    });
  }

  Future<void> _deleteBook(Book book) async {
    await _storageService.deleteBook(book.id);
    setState(() {
      _books.removeWhere((b) => b.id == book.id);
      _hasChanges = true;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted "${book.title}"'),
          duration: const Duration(seconds: 2),
          backgroundColor: DesignSystem.primaryBlack,
        ),
      );
    }
  }

  void _showDeleteConfirmation(Book book) {
    final isDark = context.read<ThemeProvider>().isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignSystem.cardColor(isDark),
        shape: const RoundedRectangleBorder(),
        contentPadding: const EdgeInsets.all(DesignSystem.spacingLG),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DELETE BOOK?',
              style: DesignSystem.text2XL.copyWith(
                fontWeight: FontWeight.w900,
                color: DesignSystem.textColor(isDark),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingMD),
            Text(
              'Are you sure you want to delete "${book.title}"? This action cannot be undone.',
              style: DesignSystem.textBase.copyWith(
                color: DesignSystem.textColor(isDark),
              ),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: BrutalButton(
                  text: 'CANCEL',
                  variant: BrutalButtonVariant.outline,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: BrutalButton(
                  text: 'DELETE',
                  onPressed: () {
                    Navigator.of(context).pop();
                    _deleteBook(book);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return BrutalModal(
      title: 'MANAGE BOOKS',
      onClose: () => Navigator.of(context).pop(_hasChanges),
      child: _isLoading
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingXL),
                child: CircularProgressIndicator(
                  color: DesignSystem.textColor(isDark),
                ),
              ),
            )
          : _books.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingXL),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: isDark
                          ? DesignSystem.grey500
                          : DesignSystem.grey400,
                    ),
                    const SizedBox(height: DesignSystem.spacingMD),
                    Text(
                      'NO BOOKS',
                      style: DesignSystem.textLG.copyWith(
                        fontWeight: FontWeight.w900,
                        color: isDark
                            ? DesignSystem.grey500
                            : DesignSystem.grey600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: _books.map((book) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: DesignSystem.spacingMD,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(DesignSystem.spacingSM),
                    decoration: BoxDecoration(
                      color: DesignSystem.cardColor(isDark),
                      border: DesignSystem.themeBorder(isDark),
                      boxShadow: DesignSystem.themeShadowSmall(isDark),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Mini Cover - Smaller
                        Container(
                          width: 50,
                          height: 70,
                          decoration: BoxDecoration(
                            color: book.coverColor ?? DesignSystem.grey200,
                            border: DesignSystem.themeBorder(isDark),
                          ),
                          child: book.coverImagePath != null
                              ? Image.asset(
                                  book.coverImagePath!,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.menu_book,
                                  size: DesignSystem.iconSizeMD,
                                  color: isDark
                                      ? DesignSystem.grey600
                                      : DesignSystem.primaryBlack,
                                ),
                        ),
                        const SizedBox(width: DesignSystem.spacingSM),
                        // Content - Flexible
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: DesignSystem.textSM.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: DesignSystem.textColor(isDark),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                book.author,
                                style: DesignSystem.textXS.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? DesignSystem.grey500
                                      : DesignSystem.grey600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: DesignSystem.spacingSM),
                        // Actions - Fixed size buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 32,
                              child: GestureDetector(
                                onTap: () async {
                                  final hasChanges = await showDialog<bool>(
                                    context: context,
                                    builder: (context) =>
                                        EditBookModal(book: book),
                                  );

                                  if (hasChanges == true) {
                                    _loadBooks();
                                    setState(() => _hasChanges = true);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: DesignSystem.cardColor(isDark),
                                    border: DesignSystem.themeBorder(isDark),
                                  ),
                                  child: Text(
                                    'EDIT',
                                    style: DesignSystem.textXS.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: DesignSystem.textColor(isDark),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            SizedBox(
                              width: 60,
                              height: 32,
                              child: GestureDetector(
                                onTap: () => _showDeleteConfirmation(book),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: DesignSystem.cardColor(isDark),
                                    border: DesignSystem.themeBorder(isDark),
                                  ),
                                  child: Text(
                                    'DELETE',
                                    style: DesignSystem.textXS.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: DesignSystem.textColor(isDark),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }
}
