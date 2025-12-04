import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../widgets/brutal_button.dart';
import '../providers/theme_provider.dart';

class HighlightDialog extends StatefulWidget {
  final String selectedText;
  final VoidCallback onSave;
  final Function(String? note, Color? color) onSaveWithData;

  const HighlightDialog({
    super.key,
    required this.selectedText,
    required this.onSave,
    required this.onSaveWithData,
  });

  @override
  State<HighlightDialog> createState() => _HighlightDialogState();
}

class _HighlightDialogState extends State<HighlightDialog> {
  final TextEditingController _noteController = TextEditingController();
  Color? _selectedColor = const Color(0xFFFFEB3B); // Yellow default

  final List<Color> _highlightColors = [
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFF4CAF50), // Green
    const Color(0xFF2196F3), // Blue
    const Color(0xFFFF9800), // Orange
    const Color(0xFFE91E63), // Pink
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Dialog(
      backgroundColor: DesignSystem.cardColor(isDark),
      shape: const RoundedRectangleBorder(),
      child: Container(
        decoration: BoxDecoration(
          border: DesignSystem.themeBorder(isDark),
          color: DesignSystem.cardColor(isDark),
        ),
        padding: const EdgeInsets.all(DesignSystem.spacingLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                Icon(
                  Icons.format_quote,
                  size: DesignSystem.iconSizeLG,
                  color: DesignSystem.textColor(isDark),
                ),
                const SizedBox(width: DesignSystem.spacingSM),
                Text(
                  'CREATE HIGHLIGHT',
                  style: DesignSystem.textLG.copyWith(
                    fontWeight: FontWeight.w900,
                    color: DesignSystem.textColor(isDark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DesignSystem.spacingLG),

            // Selected Text Preview
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              decoration: BoxDecoration(
                color: _selectedColor?.withOpacity(0.3),
                border: DesignSystem.themeBorder(isDark),
              ),
              child: Text(
                widget.selectedText,
                style: DesignSystem.textBase.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: DesignSystem.textColor(isDark),
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: DesignSystem.spacingLG),

            // Color Picker
            Text(
              'HIGHLIGHT COLOR',
              style: DesignSystem.textSM.copyWith(
                fontWeight: FontWeight.w700,
                color: DesignSystem.textColor(isDark),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingSM),
            Row(
              children: _highlightColors.map((color) {
                final isSelected = _selectedColor == color;
                return Padding(
                  padding: const EdgeInsets.only(right: DesignSystem.spacingSM),
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _selectedColor = color);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(
                          color: DesignSystem.textColor(isDark),
                          width: isSelected ? 3 : 2,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: DesignSystem
                                  .primaryBlack, // Checkmark always black on colors
                              size: DesignSystem.iconSizeMD,
                            )
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: DesignSystem.spacingLG),

            // Note Input
            Text(
              'ADD NOTE (OPTIONAL)',
              style: DesignSystem.textSM.copyWith(
                fontWeight: FontWeight.w700,
                color: DesignSystem.textColor(isDark),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingSM),
            TextField(
              controller: _noteController,
              maxLines: 3,
              style: DesignSystem.textBase.copyWith(
                color: DesignSystem.textColor(isDark),
              ),
              decoration: InputDecoration(
                hintText: 'Add your thoughts...',
                hintStyle: TextStyle(
                  color: isDark ? DesignSystem.grey500 : DesignSystem.grey400,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: DesignSystem.textColor(isDark),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: DesignSystem.textColor(isDark),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.zero,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: DesignSystem.textColor(isDark),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.zero,
                ),
                contentPadding: const EdgeInsets.all(DesignSystem.spacingMD),
              ),
            ),
            const SizedBox(height: DesignSystem.spacingLG),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BrutalButton(
                  text: 'CANCEL',
                  onPressed: () => Navigator.of(context).pop(),
                  variant: BrutalButtonVariant.secondary,
                ),
                const SizedBox(width: DesignSystem.spacingMD),
                BrutalButton(
                  text: 'SAVE',
                  onPressed: () {
                    final note = _noteController.text.trim();
                    widget.onSaveWithData(
                      note.isEmpty ? null : note,
                      _selectedColor,
                    );
                    Navigator.of(context).pop();
                  },
                  variant: BrutalButtonVariant.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
