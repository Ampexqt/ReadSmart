import 'package:flutter/material.dart';
import '../theme/design_system.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  @override
  void didUpdateWidget(HomeLibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadBooks(); // Reload when widget updates
  }

  Future<void> _loadBooks() async {
    setState(() => _isLoading = true);
    final books = await _storageService.loadBooks();
    setState(() {
      _books = books;
      _isLoading = false;
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
              title: 'LIBRARY',
              rightAction: GestureDetector(
                onTap: _showAddBookModal,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: DesignSystem.primaryBlack,
                    border: DesignSystem.border,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: DesignSystem.primaryWhite,
                    size: DesignSystem.iconSizeMD,
                  ),
                ),
              ),
            ),
            // Search Bar
            Container(
              padding: const EdgeInsets.all(DesignSystem.spacingMD),
              decoration: const BoxDecoration(
                color: DesignSystem.grey50,
                border: Border(bottom: DesignSystem.borderSide),
              ),
              child: BrutalInput(
                hintText: 'Search books...',
                controller: _searchController,
                suffixIcon: const Icon(
                  Icons.search,
                  size: DesignSystem.iconSizeMD,
                  color: DesignSystem.primaryBlack,
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
                      number: _books
                          .where((b) => b.progress > 0)
                          .length
                          .toString(),
                      label: 'READING',
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingMD),
                  Expanded(
                    child: _buildStatCard(
                      number: _books
                          .where((b) => b.progress == 1.0)
                          .length
                          .toString(),
                      label: 'FINISHED',
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
                    : GridView.builder(
                        padding: const EdgeInsets.all(DesignSystem.spacingMD),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: DesignSystem.spacingMD,
                              mainAxisSpacing: DesignSystem.spacingMD,
                              childAspectRatio: 0.55,
                            ),
                        itemCount: _books.length,
                        itemBuilder: (context, index) => BookCard(
                          title: _books[index].title,
                          author: _books[index].author,
                          progress: _books[index].progress,
                          coverColor: _books[index].coverColor,
                          coverImagePath: _books[index].coverImagePath,
                          onTap: () {
                            Navigator.of(
                              context,
                            ).pushNamed('/reader', arguments: _books[index]);
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
    return BrutalCard(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: DesignSystem.text2XL.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            label,
            style: DesignSystem.textXS.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
