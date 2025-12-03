import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:epub_view/epub_view.dart';
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
  EpubController? _epubController;
  Book? _book;

  // Track current EPUB chapter index for navigation
  int _currentEpubChapterIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_book == null) {
      final book = ModalRoute.of(context)!.settings.arguments as Book?;
      if (book != null) {
        _book = book;
        _loadFile(book);
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
            _epubController = EpubController(
              document: EpubDocument.openData(_fileBytes!),
            );
          }
        }
      } else {
        // Mobile: Use file path
        if (isEpub) {
          final file = File(book.filePath!);
          final bytes = await file.readAsBytes();
          _epubController = EpubController(
            document: EpubDocument.openData(bytes),
          );
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

  void _onEpubChapterChanged(value) {
    if (value != null) {
      setState(() {
        _currentEpubChapterIndex = value.chapterNumber - 1;
      });
    }
  }

  void _prevChapter() {
    if (_book!.filePath!.toLowerCase().endsWith('.pdf')) {
      _pdfController.previousPage();
    } else {
      // EPUB
      if (_epubController != null && _currentEpubChapterIndex > 0) {
        _epubController!.jumpTo(index: _currentEpubChapterIndex - 1);
      }
    }
  }

  void _nextChapter() {
    if (_book!.filePath!.toLowerCase().endsWith('.pdf')) {
      _pdfController.nextPage();
    } else {
      // EPUB
      if (_epubController != null) {
        _epubController!.jumpTo(index: _currentEpubChapterIndex + 1);
      }
    }
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
    if (_epubController == null) return const SizedBox();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
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
          ListTile(
            title: const Text('Use Next/Prev buttons to navigate'),
            leading: const Icon(Icons.info_outline),
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
      child: Row(
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
      if (_epubController != null) {
        return EpubView(
          controller: _epubController!,
          onChapterChanged: _onEpubChapterChanged,
        );
      } else {
        return const Center(
          child: Text("Could not load EPUB.", textAlign: TextAlign.center),
        );
      }
    }

    return const Center(child: Text("Unsupported file format"));
  }
}
