import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../theme/design_system.dart';
import '../widgets/brutal_modal.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_input.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';

class AddBookModal extends StatefulWidget {
  const AddBookModal({super.key});

  @override
  State<AddBookModal> createState() => _AddBookModalState();
}

class _AddBookModalState extends State<AddBookModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final BookStorageService _storageService = BookStorageService();
  File? _eBookFile;
  String? _eBookFileName; // Store filename for web
  List<int>? _fileBytes; // Store bytes for web
  File? _coverImage;
  String? _coverImagePath; // Store path for web
  Color? _selectedColor;
  bool _isSaving = false;

  final List<Color> _coverColors = [
    DesignSystem.grey200,
    DesignSystem.grey300,
    DesignSystem.grey400,
    DesignSystem.grey500,
  ];

  Future<void> _pickEBookFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf', 'mobi'],
    );

    if (result != null) {
      if (kIsWeb) {
        // Web platform - path is unavailable, use name only
        setState(() {
          _eBookFileName = result.files.single.name;
          _fileBytes = result.files.single.bytes;
          // Auto-fill title from filename if empty
          if (_titleController.text.isEmpty) {
            final fileName = result.files.single.name;
            final titleWithoutExtension = fileName.substring(
              0,
              fileName.lastIndexOf('.'),
            );
            _titleController.text = titleWithoutExtension;
          }
        });
      } else if (result.files.single.path != null) {
        // Mobile/Desktop - path is available
        setState(() {
          _eBookFile = File(result.files.single.path!);
          _eBookFileName = result.files.single.name;
          // Auto-fill title from filename if empty
          if (_titleController.text.isEmpty) {
            final fileName = result.files.single.name;
            final titleWithoutExtension = fileName.substring(
              0,
              fileName.lastIndexOf('.'),
            );
            _titleController.text = titleWithoutExtension;
          }
        });
      }
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          _coverImagePath = pickedFile.path;
          _coverImage = null;
        } else {
          _coverImage = File(pickedFile.path);
          _coverImagePath = null;
        }
      });
    }
  }

  Future<void> _saveBook() async {
    // Validate inputs
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a book title');
      return;
    }

    if (_authorController.text.trim().isEmpty) {
      _showError('Please enter an author name');
      return;
    }

    if (_eBookFileName == null) {
      _showError('Please select an ebook file');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final book = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        author: _authorController.text.trim(),
        filePath: _eBookFile?.path ?? _eBookFileName!,
        coverImagePath: _coverImage?.path ?? _coverImagePath,
        coverColor: _selectedColor ?? DesignSystem.grey200,
        dateAdded: DateTime.now(),
        progress: 0.0,
      );

      await _storageService.addBook(book);

      // Save file content for web
      if (kIsWeb && _fileBytes != null && _eBookFileName != null) {
        await _storageService.saveBookFile(_eBookFileName!, _fileBytes!);
      }

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      _showError('Failed to save book: $e');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BrutalModal(
      title: 'ADD BOOK',
      onClose: () => Navigator.of(context).pop(),
      actions: [
        BrutalButton(
          text: 'CANCEL',
          variant: BrutalButtonVariant.outline,
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: DesignSystem.spacingMD),
        BrutalButton(
          text: _isSaving ? 'SAVING...' : 'ADD BOOK',
          onPressed: _isSaving ? null : _saveBook,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // eBook File Upload
          GestureDetector(
            onTap: _pickEBookFile,
            child: Container(
              padding: const EdgeInsets.all(DesignSystem.spacingLG),
              decoration: BoxDecoration(
                color: DesignSystem.primaryWhite,
                border: Border.all(
                  color: DesignSystem.primaryBlack,
                  width: DesignSystem.borderWidth,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _eBookFileName != null
                        ? Icons.description
                        : Icons.upload_file,
                    size: DesignSystem.iconSize2XL,
                    color: DesignSystem.primaryBlack,
                  ),
                  const SizedBox(height: DesignSystem.spacingMD),
                  Text(
                    _eBookFileName ?? 'UPLOAD EBOOK FILE',
                    style: DesignSystem.textBase.copyWith(
                      fontWeight: FontWeight.w700,
                      color: DesignSystem.primaryBlack,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_eBookFileName == null) ...[
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      'EPUB, PDF, MOBI',
                      style: DesignSystem.textSM.copyWith(
                        fontWeight: FontWeight.w500,
                        color: DesignSystem.grey600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          // Form Fields - MOVED UP
          BrutalInput(
            label: 'TITLE',
            controller: _titleController,
            hintText: 'Enter book title',
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          BrutalInput(
            label: 'AUTHOR',
            controller: _authorController,
            hintText: 'Enter author name',
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          // Cover Photo Preview - SMALLER
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _selectedColor ?? DesignSystem.grey200,
              border: DesignSystem.border,
            ),
            child: _coverImage != null
                ? Image.file(_coverImage!, fit: BoxFit.cover)
                : (_coverImagePath != null
                      ? Image.network(_coverImagePath!, fit: BoxFit.cover)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 40,
                              color: DesignSystem.primaryBlack,
                            ),
                            const SizedBox(height: DesignSystem.spacingXS),
                            Text(
                              'NO PHOTO',
                              style: DesignSystem.textXS.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        )),
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          // Add Photo Button
          BrutalButton(
            text: 'ADD PHOTO',
            variant: BrutalButtonVariant.outline,
            fullWidth: true,
            icon: const Icon(
              Icons.image,
              size: DesignSystem.iconSizeMD,
              color: DesignSystem.primaryBlack,
            ),
            onPressed: _pickCoverImage,
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          // Color Selector
          Text('COVER COLOR', style: DesignSystem.labelStyle),
          const SizedBox(height: DesignSystem.spacingSM),
          Row(
            children: _coverColors.map((color) {
              final isSelected = _selectedColor == color;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    height: 40,
                    margin: EdgeInsets.only(
                      right: color != _coverColors.last
                          ? DesignSystem.spacingSM
                          : 0,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: DesignSystem.primaryBlack,
                        width: isSelected ? 3 : DesignSystem.borderWidth,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
