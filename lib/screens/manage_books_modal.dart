import 'package:flutter/material.dart';
import '../theme/design_system.dart';
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignSystem.primaryWhite,
        shape: const RoundedRectangleBorder(),
        contentPadding: const EdgeInsets.all(DesignSystem.spacingLG),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DELETE BOOK?',
              style: DesignSystem.text2XL.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: DesignSystem.spacingMD),
            Text(
              'Are you sure you want to delete "${book.title}"? This action cannot be undone.',
              style: DesignSystem.textBase,
            ),
          ],
        ),
        actions: [
          BrutalButton(
            text: 'CANCEL',
            variant: BrutalButtonVariant.outline,
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
          BrutalButton(
            text: 'DELETE',
            onPressed: () {
              Navigator.of(context).pop();
              _deleteBook(book);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrutalModal(
      title: 'MANAGE BOOKS',
      onClose: () => Navigator.of(context).pop(_hasChanges),
      child: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(DesignSystem.spacingXL),
                child: CircularProgressIndicator(
                  color: DesignSystem.primaryBlack,
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
                    const Icon(
                      Icons.book_outlined,
                      size: 48,
                      color: DesignSystem.grey400,
                    ),
                    const SizedBox(height: DesignSystem.spacingMD),
                    Text(
                      'NO BOOKS',
                      style: DesignSystem.textLG.copyWith(
                        fontWeight: FontWeight.w900,
                        color: DesignSystem.grey600,
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
                      color: DesignSystem.primaryWhite,
                      border: DesignSystem.border,
                      boxShadow: DesignSystem.shadowSmall,
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
                            border: DesignSystem.border,
                          ),
                          child: book.coverImagePath != null
                              ? Image.asset(
                                  book.coverImagePath!,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.menu_book,
                                  size: DesignSystem.iconSizeMD,
                                  color: DesignSystem.primaryBlack,
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
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                book.author,
                                style: DesignSystem.textXS.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: DesignSystem.grey600,
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
                                    color: DesignSystem.primaryWhite,
                                    border: DesignSystem.border,
                                  ),
                                  child: Text(
                                    'EDIT',
                                    style: DesignSystem.textXS.copyWith(
                                      fontWeight: FontWeight.w700,
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
                                    color: DesignSystem.primaryWhite,
                                    border: DesignSystem.border,
                                  ),
                                  child: Text(
                                    'DELETE',
                                    style: DesignSystem.textXS.copyWith(
                                      fontWeight: FontWeight.w700,
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
