import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class BookStorageService {
  static const String _booksKey = 'books';

  // Save books to local storage
  Future<void> saveBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = books.map((book) => book.toJson()).toList();
    await prefs.setString(_booksKey, jsonEncode(booksJson));
  }

  // Load books from local storage
  Future<List<Book>> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksString = prefs.getString(_booksKey);

    if (booksString == null || booksString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> booksJson = jsonDecode(booksString);
      return booksJson.map((json) => Book.fromJson(json)).toList();
    } catch (e) {
      print('Error loading books: $e');
      return [];
    }
  }

  // Add a new book
  Future<void> addBook(Book book) async {
    final books = await loadBooks();
    books.add(book);
    await saveBooks(books);
  }

  // Update an existing book
  Future<void> updateBook(Book updatedBook) async {
    final books = await loadBooks();
    final index = books.indexWhere((book) => book.id == updatedBook.id);

    if (index != -1) {
      books[index] = updatedBook;
      await saveBooks(books);
    }
  }

  // Delete a book
  Future<void> deleteBook(String bookId) async {
    final books = await loadBooks();
    books.removeWhere((book) => book.id == bookId);
    await saveBooks(books);
  }

  // Clear all books
  Future<void> clearAllBooks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_booksKey);
  }

  // Save book file content (Web only workaround)
  Future<void> saveBookFile(String fileName, List<int> bytes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('file_$fileName', base64Encode(bytes));
  }

  // Load book file content (Web only workaround)
  Future<List<int>?> loadBookFile(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final base64String = prefs.getString('file_$fileName');
    if (base64String != null) {
      return base64Decode(base64String);
    }
    return null;
  }

  // Bookmark Management
  static const String _bookmarksKey = 'bookmarks';

  Future<List<Bookmark>> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksString = prefs.getString(_bookmarksKey);

    if (bookmarksString == null || bookmarksString.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> bookmarksJson = jsonDecode(bookmarksString);
      return bookmarksJson.map((json) => Bookmark.fromJson(json)).toList();
    } catch (e) {
      print('Error loading bookmarks: $e');
      return [];
    }
  }

  Future<void> saveBookmarks(List<Bookmark> bookmarks) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = bookmarks.map((b) => b.toJson()).toList();
    await prefs.setString(_bookmarksKey, jsonEncode(bookmarksJson));
  }

  Future<void> addBookmark(Bookmark bookmark) async {
    final bookmarks = await loadBookmarks();
    bookmarks.add(bookmark);
    await saveBookmarks(bookmarks);
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    final bookmarks = await loadBookmarks();
    bookmarks.removeWhere((b) => b.id == bookmarkId);
    await saveBookmarks(bookmarks);
  }

  Future<bool> isChapterBookmarked(String bookId, int chapterIndex) async {
    final bookmarks = await loadBookmarks();
    return bookmarks.any((b) => b.bookId == bookId && b.page == chapterIndex);
  }
}
