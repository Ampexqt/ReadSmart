import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';
import '../widgets/brutal_modal.dart';
import '../widgets/brutal_input.dart';
import '../widgets/brutal_button.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';

class AddBookModal extends StatefulWidget {
  const AddBookModal({super.key});

  @override
  State<AddBookModal> createState() => _AddBookModalState();
}

class _AddBookModalState extends State<AddBookModal> {
  final BookStorageService _storageService = BookStorageService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  bool _isLoading = false;
  Color? _selectedColor = DesignSystem.grey200;
  String? _selectedFilePath;
  String? _selectedFileName;

  final List<Color> _colorOptions = [
    DesignSystem.grey200,
    DesignSystem.grey300,
    const Color(0xFFE3F2FD), // Light Blue
    const Color(0xFFFCE4EC), // Light Pink
    const Color(0xFFF3E5F5), // Light Purple
    const Color(0xFFE8F5E9), // Light Green
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub'],
        withData: true, // Important: loads file bytes for all platforms
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        final fileName = file.name;

        // Always use bytes for consistency across web and mobile
        List<int>? fileBytes = file.bytes;

        // If bytes not available, try reading from path (mobile fallback)
        if (fileBytes == null && file.path != null) {
          try {
            final fileData = await File(file.path!).readAsBytes();
            fileBytes = fileData;
          } catch (e) {
            print('Error reading file from path: $e');
          }
        }

        if (fileBytes != null) {
          // Save file bytes to storage (works for both web and mobile)
          await _storageService.saveBookFile(fileName, fileBytes);

          setState(() {
            // Use fileName as the identifier for cross-platform compatibility
            _selectedFilePath = fileName;
            _selectedFileName = fileName;
          });
        } else {
          throw Exception('Unable to access file data');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addBook() async {
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

    if (_selectedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a book file'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Create new book
    final newBook = Book(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      author: _authorController.text.trim(),
      filePath: _selectedFilePath!,
      coverColor: _selectedColor,
      progress: 0.0,
      dateAdded: DateTime.now(),
    );

    // Add the book to storage
    await _storageService.addBook(newBook);

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.of(
        context,
      ).pop(true); // Return true to indicate a book was added
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return BrutalModal(
      title: 'ADD BOOK',
      onClose: () => Navigator.of(context).pop(false),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // File Picker
          Text(
            'BOOK FILE',
            style: DesignSystem.textSM.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
              color: DesignSystem.textColor(isDark),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          GestureDetector(
            onTap: _pickFile,
            child: Container(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              decoration: BoxDecoration(
                color: DesignSystem.cardColor(isDark),
                border: DesignSystem.themeBorder(isDark),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.upload_file,
                    color: DesignSystem.textColor(isDark),
                    size: DesignSystem.iconSizeLG,
                  ),
                  const SizedBox(width: DesignSystem.spacingMD),
                  Expanded(
                    child: Text(
                      _selectedFileName ?? 'Select EPUB file only',
                      style: DesignSystem.textBase.copyWith(
                        color: _selectedFileName != null
                            ? DesignSystem.textColor(isDark)
                            : (isDark
                                  ? DesignSystem.grey500
                                  : DesignSystem.grey600),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingMD),

          // Title Input
          Text(
            'TITLE',
            style: DesignSystem.textSM.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.05,
              color: DesignSystem.textColor(isDark),
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
              color: DesignSystem.textColor(isDark),
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
              color: DesignSystem.textColor(isDark),
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
                        ? Border.all(color: DesignSystem.primaryBlack, width: 3)
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
              const SizedBox(width: DesignSystem.spacingSM),
              Expanded(
                child: BrutalButton(
                  text: _isLoading ? 'ADDING...' : 'ADD BOOK',
                  onPressed: _isLoading ? null : _addBook,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
