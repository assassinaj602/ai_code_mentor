import 'package:uuid/uuid.dart';

class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String imageUrl;
  final DateTime publishDate;
  final String author;

  NewsArticle({
    String? id,
    required this.title,
    required this.summary,
    required this.content,
    required this.imageUrl,
    required this.publishDate,
    required this.author,
  }) : id = id ?? const Uuid().v4();

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String,
      publishDate: DateTime.parse(json['publishDate'] as String),
      author: json['author'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'summary': summary,
        'content': content,
        'imageUrl': imageUrl,
        'publishDate': publishDate.toIso8601String(),
        'author': author,
      };

  NewsArticle copyWith({
    String? title,
    String? summary,
    String? content,
    String? imageUrl,
    DateTime? publishDate,
    String? author,
  }) {
    return NewsArticle(
      id: id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      publishDate: publishDate ?? this.publishDate,
      author: author ?? this.author,
    );
  }
}
