import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final double progress; // 0.0 to 1.0
  final String? coverImagePath;
  final Color? coverColor;
  final String? filePath;
  final DateTime? dateAdded;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.progress = 0.0,
    this.coverImagePath,
    this.coverColor,
    this.filePath,
    this.dateAdded,
  });
}

class Highlight {
  final String id;
  final String bookId;
  final String bookTitle;
  final String text;
  final int page;
  final DateTime date;

  Highlight({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.text,
    required this.page,
    required this.date,
  });
}

class Bookmark {
  final String id;
  final String bookId;
  final String bookTitle;
  final String? chapter;
  final int page;
  final DateTime date;
  final String? coverImagePath;
  final Color? coverColor;

  Bookmark({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    this.chapter,
    required this.page,
    required this.date,
    this.coverImagePath,
    this.coverColor,
  });
}
