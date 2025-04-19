import 'achievement.dart';

class UserProgress {
  final String gameId;
  final double hoursPlayed;
  final double completionPercentage;
  final DateTime lastPlayed;
  final List<Achievement> achievements;

  UserProgress({
    required this.gameId,
    this.hoursPlayed = 0.0,
    this.completionPercentage = 0.0,
    required this.lastPlayed,
    required this.achievements,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      gameId: json['gameId'] as String,
      hoursPlayed: (json['hoursPlayed'] as num).toDouble(),
      completionPercentage: (json['completionPercentage'] as num).toDouble(),
      lastPlayed: DateTime.parse(json['lastPlayed'] as String),
      achievements: (json['achievements'] as List)
          .map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'hoursPlayed': hoursPlayed,
        'completionPercentage': completionPercentage,
        'lastPlayed': lastPlayed.toIso8601String(),
        'achievements': achievements.map((e) => e.toJson()).toList(),
      };

  UserProgress copyWith({
    double? hoursPlayed,
    double? completionPercentage,
    DateTime? lastPlayed,
    List<Achievement>? achievements,
  }) {
    return UserProgress(
      gameId: gameId,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      achievements: achievements ?? this.achievements,
    );
  }
}
