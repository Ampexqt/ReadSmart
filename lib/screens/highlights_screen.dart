import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/brutal_card.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';

class HighlightsScreen extends StatefulWidget {
  const HighlightsScreen({super.key});

  @override
  State<HighlightsScreen> createState() => _HighlightsScreenState();
}

class _HighlightsScreenState extends State<HighlightsScreen> {
  final BookStorageService _storageService = BookStorageService();
  List<Highlight> _highlights = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHighlights();
  }

  Future<void> _loadHighlights() async {
    setState(() => _isLoading = true);
    final highlights = await _storageService.loadHighlights();
    setState(() {
      _highlights = highlights;
      _isLoading = false;
    });
  }

  Future<void> _deleteHighlight(String highlightId) async {
    await _storageService.deleteHighlight(highlightId);
    _loadHighlights();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Highlight deleted'),
          duration: Duration(seconds: 2),
          backgroundColor: DesignSystem.primaryBlack,
        ),
      );
    }
  }

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
                    Expanded(
                      child: Text(
                        'TOTAL HIGHLIGHTS',
                        style: DesignSystem.textSM.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Highlights List
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: DesignSystem.primaryBlack,
                      ),
                    )
                  : _highlights.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.format_quote,
                            size: 64,
                            color: DesignSystem.grey400,
                          ),
                          const SizedBox(height: DesignSystem.spacingMD),
                          Text(
                            'NO HIGHLIGHTS YET',
                            style: DesignSystem.textLG.copyWith(
                              fontWeight: FontWeight.w900,
                              color: DesignSystem.grey600,
                            ),
                          ),
                          const SizedBox(height: DesignSystem.spacingSM),
                          Text(
                            'Select text while reading to\ncreate your first highlight',
                            textAlign: TextAlign.center,
                            style: DesignSystem.textBase.copyWith(
                              color: DesignSystem.grey600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
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
                        return Dismissible(
                          key: Key(highlight.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(
                              right: DesignSystem.spacingLG,
                            ),
                            color: Colors.red,
                            child: const Icon(
                              Icons.delete,
                              color: DesignSystem.primaryWhite,
                              size: DesignSystem.iconSizeLG,
                            ),
                          ),
                          onDismissed: (direction) {
                            _deleteHighlight(highlight.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: DesignSystem.spacingMD,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 60,
                                  color:
                                      highlight.highlightColor ??
                                      const Color(0xFFFFEB3B),
                                  margin: const EdgeInsets.only(
                                    right: DesignSystem.spacingMD,
                                  ),
                                ),
                                const Icon(
                                  Icons.format_quote,
                                  size: DesignSystem.iconSizeLG,
                                  color: DesignSystem.primaryBlack,
                                ),
                                const SizedBox(width: DesignSystem.spacingMD),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(
                                          DesignSystem.spacingSM,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              highlight.highlightColor
                                                  ?.withOpacity(0.2) ??
                                              const Color(
                                                0xFFFFEB3B,
                                              ).withOpacity(0.2),
                                        ),
                                        child: Text(
                                          highlight.text,
                                          style: DesignSystem.textBase.copyWith(
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      if (highlight.note != null &&
                                          highlight.note!.isNotEmpty) ...[
                                        const SizedBox(
                                          height: DesignSystem.spacingSM,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(
                                            DesignSystem.spacingSM,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: DesignSystem.grey300,
                                              width: 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.note,
                                                size: 16,
                                                color: DesignSystem.grey600,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  highlight.note!,
                                                  style: DesignSystem.textSM
                                                      .copyWith(
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: DesignSystem
                                                            .grey700,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      const SizedBox(
                                        height: DesignSystem.spacingSM,
                                      ),
                                      Text(
                                        highlight.bookTitle,
                                        style: DesignSystem.textSM.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: DesignSystem.spacingXS,
                                      ),
                                      Text(
                                        '${highlight.chapter ?? 'Chapter ${highlight.page + 1}'} • ${_formatDate(highlight.date)}',
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
