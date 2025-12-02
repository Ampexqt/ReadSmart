import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/brutal_card.dart';
import '../models/book.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  final List<Highlight> _highlights = [
    Highlight(
      id: '1',
      bookId: '1',
      bookTitle: 'The Great Gatsby',
      text:
          'So we beat on, boats against the current, borne back ceaselessly into the past.',
      page: 180,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Highlight(
      id: '2',
      bookId: '2',
      bookTitle: '1984',
      text: 'War is peace. Freedom is slavery. Ignorance is strength.',
      page: 7,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Highlight(
      id: '3',
      bookId: '1',
      bookTitle: 'The Great Gatsby',
      text:
          'I hope she\'ll be a fool—that\'s the best thing a girl can be in this world, a beautiful little fool.',
      page: 17,
      date: DateTime.now().subtract(const Duration(days: 7)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              title: 'HIGHLIGHTS',
              rightAction: const Icon(
                Icons.filter_list,
                size: DesignSystem.iconSizeLG,
                color: DesignSystem.primaryBlack,
              ),
            ),
            // Stats Card
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              child: BrutalCard(
                padding: const EdgeInsets.all(DesignSystem.spacingLG),
                child: Row(
                  children: [
                    const Icon(
                      Icons.format_quote,
                      size: DesignSystem.iconSizeLG,
                      color: DesignSystem.primaryBlack,
                    ),
                    const SizedBox(width: DesignSystem.spacingMD),
                    Text(
                      _highlights.length.toString(),
                      style: DesignSystem.text3XL.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(width: DesignSystem.spacingSM),
                    Text(
                      'TOTAL HIGHLIGHTS',
                      style: DesignSystem.textSM.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Highlights List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignSystem.spacingMD,
                ),
                itemCount: _highlights.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 2,
                  color: DesignSystem.primaryBlack,
                ),
                itemBuilder: (context, index) {
                  final highlight = _highlights[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: DesignSystem.spacingMD,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.format_quote,
                          size: DesignSystem.iconSizeLG,
                          color: DesignSystem.primaryBlack,
                        ),
                        const SizedBox(width: DesignSystem.spacingMD),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                highlight.text,
                                style: DesignSystem.textBase.copyWith(
                                  fontWeight: FontWeight.w500,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: DesignSystem.spacingSM),
                              Text(
                                highlight.bookTitle,
                                style: DesignSystem.textSM.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: DesignSystem.spacingXS),
                              Text(
                                'Page ${highlight.page} • ${_formatDate(highlight.date)}',
                                style: DesignSystem.textXS.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: DesignSystem.grey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentItem: BottomNavItem.highlights,
        onItemSelected: (item) {
          if (item == BottomNavItem.home) {
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (item == BottomNavItem.bookmarks) {
            Navigator.of(context).pushReplacementNamed('/bookmarks');
          } else if (item == BottomNavItem.settings) {
            Navigator.of(context).pushReplacementNamed('/settings');
          }
        },
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
