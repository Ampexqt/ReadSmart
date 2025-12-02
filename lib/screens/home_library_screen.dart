import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/brutal_input.dart';
import '../widgets/book_card.dart';
import '../widgets/brutal_card.dart';
import '../models/book.dart';
import 'add_book_modal.dart';

class HomeLibraryScreen extends StatefulWidget {
  const HomeLibraryScreen({super.key});

  @override
  State<HomeLibraryScreen> createState() => _HomeLibraryScreenState();
}

class _HomeLibraryScreenState extends State<HomeLibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Book> _books = [
    Book(
      id: '1',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      progress: 0.65,
      coverColor: DesignSystem.grey200,
    ),
    Book(
      id: '2',
      title: '1984',
      author: 'George Orwell',
      progress: 0.30,
      coverColor: DesignSystem.grey300,
    ),
    Book(
      id: '3',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      progress: 0.0,
      coverColor: DesignSystem.grey200,
    ),
    Book(
      id: '4',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      progress: 1.0,
      coverColor: DesignSystem.grey300,
    ),
  ];

  void _showAddBookModal() {
    showDialog(context: context, builder: (context) => const AddBookModal());
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
              child: GridView.builder(
                padding: const EdgeInsets.all(DesignSystem.spacingMD),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: DesignSystem.spacingMD,
                  mainAxisSpacing: DesignSystem.spacingMD,
                  childAspectRatio: 0.7,
                ),
                itemCount: _books.length,
                itemBuilder: (context, index) => BookCard(
                  title: _books[index].title,
                  author: _books[index].author,
                  progress: _books[index].progress,
                  coverColor: _books[index].coverColor,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).pushNamed('/reader', arguments: _books[index]);
                  },
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
