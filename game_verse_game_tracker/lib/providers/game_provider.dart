import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game.dart';
import '../services/mock_data.dart';
import '../services/game_api_service.dart';

class GameProvider with ChangeNotifier {
  List<Game> _games = [];
  List<String> _wishlist = [];
  List<Game> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  final SharedPreferences _prefs;
  final GameApiService _apiService = GameApiService();

  GameProvider(this._prefs) {
    _loadGames();
    _loadWishlist();
  }

  List<Game> get games => _games;
  List<String> get wishlist => _wishlist;
  List<Game> get wishlistedGames => _games.where((game) => _wishlist.contains(game.id)).toList();
  List<Game> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Made public so it can be called from UI for retry functionality
  Future<void> loadGames() async {
    _setLoading(true);
    try {
      final apiGames = await _apiService.getPopularGames();
      if (apiGames.isNotEmpty) {
        _games = apiGames;
        _errorMessage = '';
      } else {
        // Fallback to mock data if API fails
        _games = MockData.games;
        _errorMessage = 'Using mock data - could not fetch from API';
      }
    } catch (e) {
      _errorMessage = 'Error loading games: $e';
      _games = MockData.games; // Fallback to mock data
    } finally {
      _setLoading(false);
    }
  }
  
  // Private method for backward compatibility
  Future<void> _loadGames() => loadGames();

  Future<void> _loadWishlist() async {
    final wishlistJson = _prefs.getStringList('wishlist') ?? [];
    _wishlist = wishlistJson;
    notifyListeners();
  }

  Future<void> toggleWishlist(String gameId) async {
    if (_wishlist.contains(gameId)) {
      _wishlist.remove(gameId);
    } else {
      _wishlist.add(gameId);
    }
    await _prefs.setStringList('wishlist', _wishlist);
    notifyListeners();
  }

  bool isInWishlist(String gameId) {
    return _wishlist.contains(gameId);
  }

  Future<void> searchGames(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    _searchResults = [];
    
    try {
      final results = await _apiService.searchGames(query);
      _searchResults = results;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = 'Error searching games: $e';
    } finally {
      _setLoading(false);
    }
  }

  Future<Game?> getGameDetails(String gameId) async {
    try {
      return await _apiService.getGameDetails(gameId);
    } catch (e) {
      _errorMessage = 'Error fetching game details: $e';
      return null;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  bool isWishlisted(String gameId) => _wishlist.contains(gameId);

  // Local search function for filtering games already loaded
  List<Game> filterGames(String query) {
    if (query.isEmpty) return _games;
    
    final lowercaseQuery = query.toLowerCase();
    return _games.where((game) {
      return game.title.toLowerCase().contains(lowercaseQuery) ||
          game.developer.toLowerCase().contains(lowercaseQuery) ||
          game.publisher.toLowerCase().contains(lowercaseQuery) ||
          game.genres.any((genre) => genre.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }
  
  // Filter games by genre
  List<Game> filterByGenre(String genre) {
    if (genre.isEmpty) return _games;
    
    return _games.where((game) {
      return game.genres.any((g) => g.toLowerCase() == genre.toLowerCase());
    }).toList();
  }

  Game? getGameById(String id) {
    try {
      return _games.firstWhere((game) => game.id == id);
    } catch (e) {
      return null;
    }
  }
}
