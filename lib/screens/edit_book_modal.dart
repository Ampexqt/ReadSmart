import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';
import '../widgets/brutal_modal.dart';
import '../widgets/brutal_input.dart';
import '../widgets/brutal_button.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';

class EditBookModal extends StatefulWidget {
  final Book book;

  const EditBookModal({super.key, required this.book});

  @override
  State<EditBookModal> createState() => _EditBookModalState();
}

class _EditBookModalState extends State<EditBookModal> {
  final BookStorageService _storageService = BookStorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  bool _isLoading = false;
  Color? _selectedColor;

  final List<Color> _colorOptions = [
    DesignSystem.grey200,
    DesignSystem.grey300,
    const Color(0xFFE3F2FD), // Light Blue
    const Color(0xFFFCE4EC), // Light Pink
    const Color(0xFFF3E5F5), // Light Purple
    const Color(0xFFE8F5E9), // Light Green
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill with existing book data
    _titleController.text = widget.book.title;
    _authorController.text = widget.book.author;
    _selectedColor = widget.book.coverColor ?? DesignSystem.grey200;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a book title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_authorController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an author name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Create updated book with same ID and file path
    final updatedBook = Book(
      id: widget.book.id,
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      filePath: widget.book.filePath,
      coverImagePath: widget.book.coverImagePath,
      coverColor: _selectedColor,
      progress: widget.book.progress,
      dateAdded: widget.book.dateAdded,
    );

    // Update the book in storage
    final books = await _storageService.loadBooks();
    final index = books.indexWhere((b) => b.id == widget.book.id);
    if (index != -1) {
      books[index] = updatedBook;
      await _storageService.saveBooks(books);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(
        context,
      ).pop(true); // Return true to indicate changes were made
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrutalModal(
      title: 'EDIT BOOK',
      onClose: () => Navigator.of(context).pop(false),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              Text(
                'TITLE',
                style: DesignSystem.textSM.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                  color: DesignSystem.textColor(
                    context.watch<ThemeProvider>().isDarkMode,
                  ),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingSM),
              BrutalInput(
                hintText: 'Enter book title',
                controller: _titleController,
              ),
              const SizedBox(height: DesignSystem.spacingMD),

              // Author Input
              Text(
                'AUTHOR',
                style: DesignSystem.textSM.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                  color: DesignSystem.textColor(
                    context.watch<ThemeProvider>().isDarkMode,
                  ),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingSM),
              BrutalInput(
                hintText: 'Enter author name',
                controller: _authorController,
              ),
              const SizedBox(height: DesignSystem.spacingMD),

              // Cover Color Selection
              Text(
                'COVER COLOR',
                style: DesignSystem.textSM.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.05,
                  color: DesignSystem.textColor(
                    context.watch<ThemeProvider>().isDarkMode,
                  ),
                ),
              ),
              const SizedBox(height: DesignSystem.spacingSM),
              Wrap(
                spacing: DesignSystem.spacingSM,
                runSpacing: DesignSystem.spacingSM,
                children: _colorOptions.map((color) {
                  final isSelected = _selectedColor == color;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        border: isSelected
                            ? Border.all(
                                color: DesignSystem.primaryBlack,
                                width: 3,
                              )
                            : DesignSystem.border,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: DesignSystem.primaryBlack,
                              size: 20,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: DesignSystem.spacingMD),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: BrutalButton(
                      text: 'CANCEL',
                      variant: BrutalButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingMD),
                  Expanded(
                    child: BrutalButton(
                      text: _isLoading ? 'SAVING...' : 'SAVE',
                      onPressed: _isLoading ? null : _saveChanges,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
