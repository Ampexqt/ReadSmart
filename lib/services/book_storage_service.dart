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
}
