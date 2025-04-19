import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_progress.dart';
import '../models/achievement.dart';

class ProgressProvider with ChangeNotifier {
  Map<String, UserProgress> _progress = {};
  final SharedPreferences _prefs;

  ProgressProvider(this._prefs) {
    _loadProgress();
  }

  UserProgress? getProgress(String gameId) => _progress[gameId];

  Future<void> _loadProgress() async {
    final progressJson = _prefs.getString('user_progress');
    if (progressJson != null) {
      final Map<String, dynamic> decoded = json.decode(progressJson);
      _progress = decoded.map(
        (key, value) => MapEntry(
          key,
          UserProgress.fromJson(value as Map<String, dynamic>),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> _saveProgress() async {
    final progressJson = json.encode(
      _progress.map((key, value) => MapEntry(key, value.toJson())),
    );
    await _prefs.setString('user_progress', progressJson);
  }

  Future<void> updatePlaytime(String gameId, double hours) async {
    final progress = _progress[gameId];
    if (progress != null) {
      _progress[gameId] = progress.copyWith(
        hoursPlayed: progress.hoursPlayed + hours,
        lastPlayed: DateTime.now(),
      );
    } else {
      _progress[gameId] = UserProgress(
        gameId: gameId,
        hoursPlayed: hours,
        completionPercentage: 0.0,
        lastPlayed: DateTime.now(),
        achievements: [],
      );
    }
    await _saveProgress();
    notifyListeners();
  }

  Future<void> updateCompletion(String gameId, double percentage) async {
    final progress = _progress[gameId];
    if (progress != null) {
      _progress[gameId] = progress.copyWith(
        completionPercentage: percentage,
        lastPlayed: DateTime.now(),
      );
      await _saveProgress();
      notifyListeners();
    }
  }

  Future<void> unlockAchievement(String gameId, Achievement achievement) async {
    final progress = _progress[gameId];
    if (progress != null) {
      final updatedAchievements = List<Achievement>.from(progress.achievements);
      final achievementIndex = updatedAchievements
          .indexWhere((element) => element.id == achievement.id);

      if (achievementIndex != -1) {
        updatedAchievements[achievementIndex] =
            achievement.copyWith(isUnlocked: true, unlockedAt: DateTime.now());
      } else {
        updatedAchievements.add(
          achievement.copyWith(isUnlocked: true, unlockedAt: DateTime.now()),
        );
      }

      _progress[gameId] = progress.copyWith(achievements: updatedAchievements);
      await _saveProgress();
      notifyListeners();
    }
  }
}
