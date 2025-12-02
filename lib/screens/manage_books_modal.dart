import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/brutal_modal.dart';
import '../widgets/brutal_button.dart';
import '../models/book.dart';

class ManageBooksModal extends StatefulWidget {
  const ManageBooksModal({super.key});

  @override
  State<ManageBooksModal> createState() => _ManageBooksModalState();
}

class _ManageBooksModalState extends State<ManageBooksModal> {
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      progress: 0.65,
      coverColor: DesignSystem.grey200,
    ),
    Book(
      id: '2',
      title: '1984',
      author: 'George Orwell',
      progress: 0.30,
      coverColor: DesignSystem.grey300,
    ),
    Book(
      id: '3',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      progress: 0.0,
      coverColor: DesignSystem.grey200,
    ),
    Book(
      id: '4',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      progress: 1.0,
      coverColor: DesignSystem.grey300,
    ),
  ];

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
              setState(() {
                _books.removeWhere((b) => b.id == book.id);
              });
              Navigator.of(context).pop();
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
      onClose: () => Navigator.of(context).pop(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _books.map((book) {
          return Padding(
            padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
            child: Container(
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
                    width: 64,
                    height: 80,
                    decoration: BoxDecoration(
                      color: book.coverColor ?? DesignSystem.grey200,
                      border: DesignSystem.border,
                    ),
                    child: book.coverImagePath != null
                        ? Image.asset(book.coverImagePath!, fit: BoxFit.cover)
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
                          book.title,
                          style: DesignSystem.textSM.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: DesignSystem.spacingXS),
                        Text(
                          book.author,
                          style: DesignSystem.textXS.copyWith(
                            fontWeight: FontWeight.w500,
                            color: DesignSystem.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Actions
                  BrutalButton(
                    text: 'EDIT',
                    size: BrutalButtonSize.sm,
                    variant: BrutalButtonVariant.outline,
                    onPressed: () {
                      // Handle edit
                    },
                  ),
                  const SizedBox(width: DesignSystem.spacingSM),
                  GestureDetector(
                    onTap: () => _showDeleteConfirmation(book),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: DesignSystem.spacingSM,
                        vertical: DesignSystem.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: DesignSystem.primaryWhite,
                        border: DesignSystem.borderSmall,
                      ),
                      child: Text(
                        'DELETE',
                        style: DesignSystem.textXS.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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
