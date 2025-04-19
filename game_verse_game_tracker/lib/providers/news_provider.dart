import 'package:flutter/foundation.dart';
import '../models/news_article.dart';
import '../services/mock_data.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _articles = [];

  NewsProvider() {
    _loadArticles();
  }

  List<NewsArticle> get articles => _articles;

  Future<void> _loadArticles() async {
    // In a real app, this would be an API call
    _articles = MockData.newsArticles;
    notifyListeners();
  }

  NewsArticle? getArticleById(String id) {
    try {
      return _articles.firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  List<NewsArticle> searchArticles(String query) {
    final lowercaseQuery = query.toLowerCase();
    return _articles.where((article) {
      return article.title.toLowerCase().contains(lowercaseQuery) ||
          article.summary.toLowerCase().contains(lowercaseQuery) ||
          article.author.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
