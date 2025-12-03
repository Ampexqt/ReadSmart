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

  // Convert Book to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'progress': progress,
      'coverImagePath': coverImagePath,
      'coverColor': coverColor?.value,
      'filePath': filePath,
      'dateAdded': dateAdded?.toIso8601String(),
    };
  }

  // Create Book from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      coverImagePath: json['coverImagePath'] as String?,
      coverColor: json['coverColor'] != null
          ? Color(json['coverColor'] as int)
          : null,
      filePath: json['filePath'] as String?,
      dateAdded: json['dateAdded'] != null
          ? DateTime.parse(json['dateAdded'] as String)
          : null,
    );
  }

  // Create a copy with updated fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    double? progress,
    String? coverImagePath,
    Color? coverColor,
    String? filePath,
    DateTime? dateAdded,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      progress: progress ?? this.progress,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      coverColor: coverColor ?? this.coverColor,
      filePath: filePath ?? this.filePath,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
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
