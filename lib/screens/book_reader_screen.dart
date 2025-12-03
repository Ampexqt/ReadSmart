import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../theme/design_system.dart';
import '../widgets/mobile_header.dart';
import '../models/book.dart';
import '../services/book_storage_service.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({super.key});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final BookStorageService _storageService = BookStorageService();
  final PdfViewerController _pdfController = PdfViewerController();

  bool _isLoading = true;
  Uint8List? _fileBytes;
  EpubBook? _epubBook; // Use EpubBook directly
  List<EpubChapter> _allChapters = []; // Flattened list of chapters
  Book? _book;

  // Track current EPUB chapter index for navigation
  int _currentEpubChapterIndex = 0;
  final ScrollController _epubScrollController = ScrollController();

  // Bookmark state
  bool _isBookmarked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_book == null) {
      final book = ModalRoute.of(context)!.settings.arguments as Book?;
      if (book != null) {
        _book = book;
        _loadFile(book);
        _checkBookmarkStatus();
      }
    }
  }

  Future<void> _loadFile(Book book) async {
    setState(() => _isLoading = true);

    try {
      final isEpub = book.filePath!.toLowerCase().endsWith('.epub');

      if (kIsWeb) {
        // Web: Load bytes from storage
        final bytes = await _storageService.loadBookFile(book.filePath!);
        if (bytes != null) {
          _fileBytes = Uint8List.fromList(bytes);

          if (isEpub) {
            // Parse EPUB
            _epubBook = await EpubReader.readBook(_fileBytes!);
            _allChapters = _flattenChapters(_epubBook!.Chapters ?? []);
          }
        }
      } else {
        // Mobile: Use file path
        if (isEpub) {
          final file = File(book.filePath!);
          final bytes = await file.readAsBytes();
          _epubBook = await EpubReader.readBook(bytes);
          _allChapters = _flattenChapters(_epubBook!.Chapters ?? []);
        }
      }
    } catch (e) {
      print('Error loading book: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Helper to flatten nested chapters
  List<EpubChapter> _flattenChapters(List<EpubChapter> chapters) {
    List<EpubChapter> result = [];
    for (var chapter in chapters) {
      result.add(chapter);
      if (chapter.SubChapters != null && chapter.SubChapters!.isNotEmpty) {
        result.addAll(_flattenChapters(chapter.SubChapters!));
      }
    }
    return result;
  }

  Future<void> _checkBookmarkStatus() async {
    if (_book != null) {
      final isBookmarked = await _storageService.isChapterBookmarked(
        _book!.id,
        _currentEpubChapterIndex,
      );
      if (mounted) {
        setState(() => _isBookmarked = isBookmarked);
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (_book == null || _allChapters.isEmpty) return;

    if (_isBookmarked) {
      // Remove bookmark
      final bookmarks = await _storageService.loadBookmarks();
      final bookmark = bookmarks.firstWhere(
        (b) => b.bookId == _book!.id && b.page == _currentEpubChapterIndex,
      );
      await _storageService.deleteBookmark(bookmark.id);
      setState(() => _isBookmarked = false);
    } else {
      // Add bookmark
      final bookmark = Bookmark(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        bookId: _book!.id,
        bookTitle: _book!.title,
        chapter:
            _allChapters[_currentEpubChapterIndex].Title ??
            'Chapter ${_currentEpubChapterIndex + 1}',
        page: _currentEpubChapterIndex,
        date: DateTime.now(),
        coverImagePath: _book!.coverImagePath,
        coverColor: _book!.coverColor,
      );
      await _storageService.addBookmark(bookmark);
      setState(() => _isBookmarked = true);
    }
  }

  void _prevChapter() {
    if (_book!.filePath!.toLowerCase().endsWith('.pdf')) {
      _pdfController.previousPage();
    } else {
      // EPUB
      if (_currentEpubChapterIndex > 0) {
        setState(() {
          _currentEpubChapterIndex--;
          _epubScrollController.jumpTo(0); // Reset scroll
        });
        _checkBookmarkStatus();
      }
    }
  }

  void _nextChapter() {
    if (_book!.filePath!.toLowerCase().endsWith('.pdf')) {
      _pdfController.nextPage();
    } else {
      // EPUB
      if (_currentEpubChapterIndex < _allChapters.length - 1) {
        setState(() {
          _currentEpubChapterIndex++;
          _epubScrollController.jumpTo(0); // Reset scroll
        });
        _checkBookmarkStatus();
      }
    }
  }

  void _jumpToChapter(int index) {
    setState(() {
      _currentEpubChapterIndex = index;
      _epubScrollController.jumpTo(0);
    });
    _checkBookmarkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.primaryWhite,
      drawer: _buildDrawer(),
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
              title: _book?.title ?? 'READING',
              onBack: () => Navigator.of(context).pop(),
              rightAction: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  color: DesignSystem.primaryBlack,
                ),
              ),
            ),
            // Content Area
            Expanded(child: _buildViewer()),
            // Navigation Bar
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    if (_allChapters.isEmpty) return const SizedBox();

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: DesignSystem.primaryBlack),
            child: Center(
              child: Text(
                'Table of Contents',
                style: TextStyle(
                  color: DesignSystem.primaryWhite,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _allChapters.length,
              itemBuilder: (context, index) {
                final chapter = _allChapters[index];
                final isSelected = index == _currentEpubChapterIndex;
                return ListTile(
                  title: Text(
                    chapter.Title ?? 'Chapter ${index + 1}',
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? DesignSystem.primaryBlack : null,
                    ),
                  ),
                  onTap: () {
                    _jumpToChapter(index);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingMD),
      decoration: const BoxDecoration(
        color: DesignSystem.primaryWhite,
        border: Border(top: DesignSystem.borderSide),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Control buttons (Bookmark & Highlight)
          if (_book != null && _book!.filePath!.toLowerCase().endsWith('.epub'))
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildControlButton(
                  icon: Icons.bookmark,
                  isActive: _isBookmarked,
                  onTap: _toggleBookmark,
                ),
                const SizedBox(width: DesignSystem.spacingMD),
                _buildControlButton(
                  icon: Icons.format_quote,
                  isActive: false,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Highlight feature coming soon!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          const SizedBox(height: DesignSystem.spacingMD),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: _prevChapter,
                icon: const Icon(
                  Icons.chevron_left,
                  color: DesignSystem.primaryWhite,
                ),
                label: const Text(
                  'PREV',
                  style: TextStyle(color: DesignSystem.primaryWhite),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignSystem.primaryBlack,
                  shape: const RoundedRectangleBorder(),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _nextChapter,
                icon: const Icon(
                  Icons.chevron_right,
                  color: DesignSystem.primaryWhite,
                ),
                label: const Text(
                  'NEXT',
                  style: TextStyle(color: DesignSystem.primaryWhite),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: DesignSystem.primaryBlack,
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildViewer() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: DesignSystem.primaryBlack),
      );
    }

    if (_book == null || _book!.filePath == null) {
      return const Center(child: Text("No book loaded"));
    }

    final isPdf = _book!.filePath!.toLowerCase().endsWith('.pdf');
    final isEpub = _book!.filePath!.toLowerCase().endsWith('.epub');

    if (isPdf) {
      if (kIsWeb) {
        if (_fileBytes != null) {
          return SfPdfViewer.memory(_fileBytes!, controller: _pdfController);
        } else {
          return const Center(
            child: Text(
              "PDF content not found in storage.\nTry adding the book again.",
              textAlign: TextAlign.center,
            ),
          );
        }
      } else {
        return SfPdfViewer.file(
          File(_book!.filePath!),
          controller: _pdfController,
        );
      }
    } else if (isEpub) {
      if (_epubBook != null && _allChapters.isNotEmpty) {
        // Render current chapter HTML
        final currentChapter = _allChapters[_currentEpubChapterIndex];
        return SingleChildScrollView(
          controller: _epubScrollController,
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: Html(
            data: currentChapter.HtmlContent ?? "<p>No content</p>",
            style: {
              "body": Style(
                fontSize: FontSize(16.0),
                lineHeight: LineHeight(1.6),
                fontFamily: 'Inter',
              ),
            },
          ),
        );
      } else {
        return const Center(
          child: Text(
            "Could not load EPUB content.",
            textAlign: TextAlign.center,
          ),
        );
      }
    }

    return const Center(child: Text("Unsupported file format"));
  }
}
