import 'package:uuid/uuid.dart';

class Review {
  final String id;
  final String gameId;
  final double rating;
  final String comment;
  final DateTime datePosted;

  Review({
    String? id,
    required this.gameId,
    required this.rating,
    required this.comment,
    required this.datePosted,
  }) : id = id ?? const Uuid().v4();

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      datePosted: DateTime.parse(json['datePosted'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'rating': rating,
        'comment': comment,
        'datePosted': datePosted.toIso8601String(),
      };

  Review copyWith({
    String? gameId,
    double? rating,
    String? comment,
    DateTime? datePosted,
  }) {
    return Review(
      id: id,
      gameId: gameId ?? this.gameId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      datePosted: datePosted ?? this.datePosted,
    );
  }
}
