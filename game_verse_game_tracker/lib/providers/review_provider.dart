import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/review.dart';
import '../services/mock_data.dart';

class ReviewProvider with ChangeNotifier {
  Map<String, List<Review>> _reviews = {};
  final SharedPreferences _prefs;

  ReviewProvider(this._prefs) {
    _loadReviews();
  }

  List<Review> getReviewsForGame(String gameId) => _reviews[gameId] ?? [];

  double getAverageRating(String gameId) {
    final gameReviews = _reviews[gameId];
    if (gameReviews == null || gameReviews.isEmpty) return 0.0;
    
    final sum = gameReviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );
    return sum / gameReviews.length;
  }

  Future<void> _loadReviews() async {
    // Load mock reviews initially
    _reviews = MockData.reviews;
    
    // Load user reviews from SharedPreferences
    final userReviewsJson = _prefs.getString('user_reviews');
    if (userReviewsJson != null) {
      final Map<String, dynamic> decoded = json.decode(userReviewsJson);
      final userReviews = decoded.map(
        (key, value) => MapEntry(
          key,
          (value as List)
              .map((review) => Review.fromJson(review as Map<String, dynamic>))
              .toList(),
        ),
      );
      // Merge mock reviews with user reviews
      _reviews.addAll(userReviews);
    }
    notifyListeners();
  }

  Future<void> _saveReviews() async {
    final reviewsJson = json.encode(_reviews.map(
      (key, value) => MapEntry(key, value.map((r) => r.toJson()).toList()),
    ));
    await _prefs.setString('user_reviews', reviewsJson);
  }

  Future<void> addReview(Review review) async {
    if (!_reviews.containsKey(review.gameId)) {
      _reviews[review.gameId] = [];
    }
    _reviews[review.gameId]!.add(review);
    await _saveReviews();
    notifyListeners();
  }

  Future<void> updateReview(Review updatedReview) async {
    final gameReviews = _reviews[updatedReview.gameId];
    if (gameReviews != null) {
      final index = gameReviews.indexWhere((r) => r.id == updatedReview.id);
      if (index != -1) {
        gameReviews[index] = updatedReview;
        await _saveReviews();
        notifyListeners();
      }
    }
  }

  Future<void> deleteReview(String gameId, String reviewId) async {
    final gameReviews = _reviews[gameId];
    if (gameReviews != null) {
      gameReviews.removeWhere((review) => review.id == reviewId);
      await _saveReviews();
      notifyListeners();
    }
  }
}
