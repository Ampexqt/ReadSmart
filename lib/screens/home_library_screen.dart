import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/design_system.dart';
import '../providers/theme_provider.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/brutal_input.dart';
import '../widgets/book_card.dart';
import '../widgets/brutal_card.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';
import 'add_book_modal.dart';

class HomeLibraryScreen extends StatefulWidget {
  const HomeLibraryScreen({super.key});

  @override
  State<HomeLibraryScreen> createState() => _HomeLibraryScreenState();
}

class _HomeLibraryScreenState extends State<HomeLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final BookStorageService _storageService = BookStorageService();
  List<Book> _books = [];
  List<Book> _filteredBooks = []; // Filtered list for search
  bool _isLoading = true;
  int? _bookmarksCount;
  int? _highlightsCount;

  @override
  void initState() {
    super.initState();
    _loadBooks();
    _loadCounts();
    // Add listener for search
    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBooks);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeLibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadBooks(); // Reload when widget updates
    _loadCounts();
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    final books = await _storageService.loadBooks();
    setState(() {
      _books = books;
      _filteredBooks = books; // Initialize filtered list
      _isLoading = false;
    });
  }

  void _filterBooks() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredBooks = _books;
      } else {
        _filteredBooks = _books.where((book) {
          final titleMatch = book.title.toLowerCase().contains(query);
          final authorMatch = book.author.toLowerCase().contains(query);
          return titleMatch || authorMatch;
        }).toList();
      }
    });
  }

  Future<void> _loadCounts() async {
    final bookmarks = await _storageService.loadBookmarks();
    final highlights = await _storageService.loadHighlights();
    setState(() {
      _bookmarksCount = bookmarks.length;
      _highlightsCount = highlights.length;
    });
  }

  void _showAddBookModal() async {
    final result = await showDialog(
      context: context,
      builder: (context) => const AddBookModal(),
    );

    // Reload books if a new book was added
    if (result == true) {
      _loadBooks();
    }
  }

  // Add this method to refresh manually
  Future<void> _refresh() async {
    await _loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      backgroundColor: DesignSystem.backgroundColor(isDark),
      body: Container(
        constraints: const BoxConstraints(maxWidth: DesignSystem.maxWidth),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width > DesignSystem.maxWidth
              ? (MediaQuery.of(context).size.width - DesignSystem.maxWidth) / 2
              : 0,
        ),
        decoration: BoxDecoration(
          border: Border(
            left: DesignSystem.themeBorderSide(isDark),
            right: DesignSystem.themeBorderSide(isDark),
          ),
        ),
        child: Column(
          children: [
            // Header
            MobileHeader(
              title: 'LIBRARY',
              rightAction: GestureDetector(
                onTap: _showAddBookModal,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DesignSystem.textColor(isDark),
                    border: DesignSystem.themeBorder(isDark),
                  ),
                  child: Icon(
                    Icons.add,
                    color: DesignSystem.backgroundColor(isDark),
                    size: DesignSystem.iconSizeMD,
                  ),
                ),
              ),
            ),
            // Search Bar
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              decoration: BoxDecoration(
                color: DesignSystem.backgroundColor(isDark),
                border: Border(bottom: DesignSystem.themeBorderSide(isDark)),
              ),
              child: BrutalInput(
                hintText: 'Search books...',
                controller: _searchController,
                suffixIcon: Icon(
                  Icons.search,
                  size: DesignSystem.iconSizeMD,
                  color: DesignSystem.textColor(isDark),
                ),
              ),
            ),
            // Stats Grid
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      number: _books.length.toString(),
                      label: 'BOOKS',
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingMD),
                  Expanded(
                    child: _buildStatCard(
                      number: (_bookmarksCount ?? 0).toString(),
                      label: 'BOOKMARKS',
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingMD),
                  Expanded(
                    child: _buildStatCard(
                      number: (_highlightsCount ?? 0).toString(),
                      label: 'HIGHLIGHTS',
                    ),
                  ),
                ],
              ),
            ),
            // Book Grid
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: DesignSystem.primaryBlack,
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: DesignSystem.primaryBlack,
                          strokeWidth: 3,
                        ),
                      )
                    : _books.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book_outlined,
                                  size: 64,
                                  color: DesignSystem.grey400,
                                ),
                                const SizedBox(height: DesignSystem.spacingMD),
                                Text(
                                  'NO BOOKS YET',
                                  style: DesignSystem.textLG.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: DesignSystem.grey600,
                                  ),
                                ),
                                const SizedBox(height: DesignSystem.spacingSM),
                                Text(
                                  'Tap the + button to add your first book',
                                  style: DesignSystem.textSM.copyWith(
                                    color: DesignSystem.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : _filteredBooks.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: DesignSystem.grey400,
                                ),
                                const SizedBox(height: DesignSystem.spacingMD),
                                Text(
                                  'NO BOOKS FOUND',
                                  style: DesignSystem.textLG.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: DesignSystem.grey600,
                                  ),
                                ),
                                const SizedBox(height: DesignSystem.spacingSM),
                                Text(
                                  'Try a different search term',
                                  style: DesignSystem.textBase.copyWith(
                                    color: DesignSystem.grey500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(DesignSystem.spacingMD),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: DesignSystem.spacingMD,
                              mainAxisSpacing: DesignSystem.spacingMD,
                              childAspectRatio: 0.55,
                            ),
                        itemCount: _filteredBooks.length,
                        itemBuilder: (context, index) => BookCard(
                          title: _filteredBooks[index].title,
                          author: _filteredBooks[index].author,
                          progress: _filteredBooks[index].progress,
                          coverColor: _filteredBooks[index].coverColor,
                          coverImagePath: _filteredBooks[index].coverImagePath,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/reader',
                              arguments: _filteredBooks[index],
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentItem: BottomNavItem.home,
        onItemSelected: (item) {
          if (item == BottomNavItem.bookmarks) {
            Navigator.of(context).pushReplacementNamed('/bookmarks');
          } else if (item == BottomNavItem.highlights) {
            Navigator.of(context).pushReplacementNamed('/highlights');
          } else if (item == BottomNavItem.settings) {
            Navigator.of(context).pushReplacementNamed('/settings');
          }
        },
      ),
    );
  }

  Widget _buildStatCard({required String number, required String label}) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return BrutalCard(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSM,
        vertical: DesignSystem.spacingMD,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: DesignSystem.text3XL.copyWith(
              fontWeight: FontWeight.w900,
              color: DesignSystem.textColor(isDark),
            ),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: DesignSystem.textXS.copyWith(
                fontWeight: FontWeight.w700,
                color: DesignSystem.textColor(isDark),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
