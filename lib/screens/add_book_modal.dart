import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../theme/design_system.dart';
import '../widgets/brutal_modal.dart';
import '../widgets/brutal_button.dart';
import '../widgets/brutal_input.dart';

class AddBookModal extends StatefulWidget {
  const AddBookModal({super.key});

  @override
  State<AddBookModal> createState() => _AddBookModalState();
}

class _AddBookModalState extends State<AddBookModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  File? _eBookFile;
  File? _coverImage;
  Color? _selectedColor;

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

    if (result != null && result.files.single.path != null) {
      setState(() {
        _eBookFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
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
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(width: DesignSystem.spacingMD),
        BrutalButton(
          text: 'ADD BOOK',
          onPressed: () {
            // Handle add book logic
            Navigator.of(context).pop();
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
                    _eBookFile != null ? Icons.description : Icons.upload_file,
                    size: DesignSystem.iconSize2XL,
                    color: DesignSystem.primaryBlack,
                  ),
                  const SizedBox(height: DesignSystem.spacingMD),
                  Text(
                    _eBookFile != null
                        ? _eBookFile!.path.split('/').last
                        : 'UPLOAD EBOOK FILE',
                    style: DesignSystem.textBase.copyWith(
                      fontWeight: FontWeight.w700,
                      color: DesignSystem.primaryBlack,
                    ),
                  ),
                  if (_eBookFile == null) ...[
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
          const SizedBox(height: DesignSystem.spacingLG),
          // Cover Photo Preview
          AspectRatio(
            aspectRatio: DesignSystem.bookCoverAspectRatio,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: _selectedColor ?? DesignSystem.grey200,
                border: DesignSystem.border,
              ),
              child: _coverImage != null
                  ? Image.file(_coverImage!, fit: BoxFit.cover)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          size: DesignSystem.iconSize3XL,
                          color: DesignSystem.primaryBlack,
                        ),
                        const SizedBox(height: DesignSystem.spacingSM),
                        Text(
                          'NO PHOTO',
                          style: DesignSystem.textSM.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
            ),
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
          const SizedBox(height: DesignSystem.spacingLG),
          // Form Fields
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
          const SizedBox(height: DesignSystem.spacingLG),
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
                    height: 48,
                    margin: EdgeInsets.only(
                      right: color != _coverColors.last
                          ? DesignSystem.spacingSM
                          : 0,
                    ),
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: DesignSystem.primaryBlack,
                        width: isSelected ? 4 : DesignSystem.borderWidth,
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
