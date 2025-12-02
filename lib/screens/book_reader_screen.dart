import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../models/book.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({super.key});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  int _currentPage = 1;
  final int _totalPages = 250;
  bool _isHighlighted = false;
  bool _isBookmarked = false;

  // Sample book content
  final String _content = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
''';

  void _previousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = ModalRoute.of(context)!.settings.arguments as Book?;

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
            MobileHeader(
              title: book?.title ?? 'READING',
              onBack: () => Navigator.of(context).pop(),
              rightAction: const Icon(
                Icons.settings,
                size: DesignSystem.iconSizeLG,
                color: DesignSystem.primaryBlack,
              ),
            ),
            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(DesignSystem.spacingLG),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 672),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _content,
                        style: DesignSystem.textBase.copyWith(
                          fontWeight: FontWeight.w500,
                          height: 1.75,
                          color: DesignSystem.primaryBlack,
                        ),
                      ),
                      const SizedBox(height: DesignSystem.spacingLG),
                      // Highlighted text example
                      Container(
                        padding: const EdgeInsets.only(
                          left: DesignSystem.spacingMD,
                        ),
                        decoration: const BoxDecoration(
                          color: DesignSystem.yellow100,
                          border: Border(
                            left: BorderSide(
                              color: DesignSystem.primaryBlack,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Text(
                          'This is a highlighted passage that stands out from the rest of the text.',
                          style: DesignSystem.textBase.copyWith(
                            fontWeight: FontWeight.w500,
                            height: 1.75,
                            color: DesignSystem.primaryBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Reading Controls
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              decoration: const BoxDecoration(
                border: Border(top: DesignSystem.borderSide),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(
                    icon: Icons.format_quote,
                    isActive: _isHighlighted,
                    onTap: () =>
                        setState(() => _isHighlighted = !_isHighlighted),
                  ),
                  const SizedBox(width: DesignSystem.spacingMD),
                  _buildControlButton(
                    icon: Icons.bookmark,
                    isActive: _isBookmarked,
                    onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                  ),
                ],
              ),
            ),
            // Page Controls
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              decoration: const BoxDecoration(
                color: DesignSystem.grey50,
                border: Border(top: DesignSystem.borderSide),
              ),
              child: Column(
                children: [
                  // Progress Bar
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: DesignSystem.grey200,
                      border: DesignSystem.borderSmall,
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _currentPage / _totalPages,
                      child: Container(color: DesignSystem.primaryBlack),
                    ),
                  ),
                  const SizedBox(height: DesignSystem.spacingMD),
                  // Page Navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _previousPage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: DesignSystem.primaryWhite,
                            border: DesignSystem.border,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            size: DesignSystem.iconSizeMD,
                            color: DesignSystem.primaryBlack,
                          ),
                        ),
                      ),
                      Text(
                        'PAGE $_currentPage / $_totalPages',
                        style: DesignSystem.textSM.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      GestureDetector(
                        onTap: _nextPage,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: DesignSystem.primaryWhite,
                            border: DesignSystem.border,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            size: DesignSystem.iconSizeMD,
                            color: DesignSystem.primaryBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive
              ? DesignSystem.primaryBlack
              : DesignSystem.primaryWhite,
          border: DesignSystem.border,
        ),
        child: Icon(
          icon,
          size: DesignSystem.iconSizeMD,
          color: isActive
              ? DesignSystem.primaryWhite
              : DesignSystem.primaryBlack,
        ),
      ),
    );
  }
}
