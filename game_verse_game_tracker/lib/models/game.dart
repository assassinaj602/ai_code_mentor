import 'package:uuid/uuid.dart';

class Game {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final String bannerImage;
  final List<String> genres;
  final DateTime releaseDate;
  final String developer;
  final String publisher;
  final double rating;
  final List<String> platforms;

  Game({
    String? id,
    required this.title,
    required this.description,
    required this.coverImage,
    required this.bannerImage,
    required this.genres,
    required this.releaseDate,
    required this.developer,
    required this.publisher,
    this.rating = 0.0,
    required this.platforms,
  }) : id = id ?? const Uuid().v4();

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      coverImage: json['coverImage'] as String,
      bannerImage: json['bannerImage'] as String,
      genres: List<String>.from(json['genres'] as List),
      releaseDate: DateTime.parse(json['releaseDate'] as String),
      developer: json['developer'] as String,
      publisher: json['publisher'] as String,
      rating: (json['rating'] as num).toDouble(),
      platforms: List<String>.from(json['platforms'] as List),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'coverImage': coverImage,
        'bannerImage': bannerImage,
        'genres': genres,
        'releaseDate': releaseDate.toIso8601String(),
        'developer': developer,
        'publisher': publisher,
        'rating': rating,
        'platforms': platforms,
      };

  Game copyWith({
    String? title,
    String? description,
    String? coverImage,
    String? bannerImage,
    List<String>? genres,
    DateTime? releaseDate,
    String? developer,
    String? publisher,
    double? rating,
    List<String>? platforms,
  }) {
    return Game(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      bannerImage: bannerImage ?? this.bannerImage,
      genres: genres ?? this.genres,
      releaseDate: releaseDate ?? this.releaseDate,
      developer: developer ?? this.developer,
      publisher: publisher ?? this.publisher,
      rating: rating ?? this.rating,
      platforms: platforms ?? this.platforms,
    );
  }
}
