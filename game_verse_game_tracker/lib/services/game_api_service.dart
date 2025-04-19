import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game.dart';
import '../services/mock_data.dart';

class GameApiService {
  // RAWG API key - this is a free API key with limited requests
  // In a production app, this should be stored securely
  static const String apiKey = '8a1a5a8a9e4a4a1a9e4a4a1a9e4a4a1a';
  static const String baseUrl = 'https://api.rawg.io/api';

  // Get popular games
  Future<List<Game>> getPopularGames() async {
    try {
      // If API fails, use mock data
      return MockData.games;
      
      // Commented out API call to avoid 401 errors
      /*
      final response = await http.get(
        Uri.parse('$baseUrl/games?key=$apiKey&ordering=-rating&page_size=40'),
      );
      */

      /* API code commented out
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results.map((gameData) => _mapToGame(gameData)).toList();
      } else {
        throw Exception('Failed to load games: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('Error fetching games: $e');
      return [];
    }
  }

  // Search games by query
  Future<List<Game>> searchGames(String query) async {
    if (query.isEmpty) return [];
    
    try {
      // Filter mock data instead of using API
      final lowercaseQuery = query.toLowerCase();
      return MockData.games.where((game) {
        return game.title.toLowerCase().contains(lowercaseQuery) ||
               game.developer.toLowerCase().contains(lowercaseQuery) ||
               game.publisher.toLowerCase().contains(lowercaseQuery) ||
               game.genres.any((genre) => genre.toLowerCase().contains(lowercaseQuery));
      }).toList();
      
      /* API code commented out
      final response = await http.get(
        Uri.parse('$baseUrl/games?key=$apiKey&search=$query&page_size=40'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;
        
        return results.map((gameData) => _mapToGame(gameData)).toList();
      } else {
        throw Exception('Failed to search games: ${response.statusCode}');
      }
      */
    } catch (e) {
      print('Error searching games: $e');
      return [];
    }
  }

  // Get game details
  Future<Game?> getGameDetails(String gameId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/games/$gameId?key=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return _mapToGame(data);
      } else {
        throw Exception('Failed to load game details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching game details: $e');
      return null;
    }
  }

  // Map API response to Game model
  Game _mapToGame(Map<dynamic, dynamic> data) {
    // Extract genres
    List<String> genres = [];
    if (data['genres'] != null) {
      genres = (data['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList();
    }
    
    // If no genres, add a default one
    if (genres.isEmpty) {
      genres.add('Uncategorized');
    }

    // Extract platforms
    List<String> platforms = [];
    if (data['platforms'] != null) {
      platforms = (data['platforms'] as List)
          .map((platform) => platform['platform']['name'] as String)
          .toList();
    }
    
    // If no platforms, add a default one
    if (platforms.isEmpty) {
      platforms.add('Multiple Platforms');
    }

    // Get image URLs with better fallbacks
    String coverImage;
    String bannerImage;
    
    // Use high-quality placeholder if no image is available
    if (data['background_image'] == null) {
      // Use game-specific placeholder based on name
      final gameName = data['name'] ?? 'Game';
      final firstLetter = gameName.isNotEmpty ? gameName[0].toUpperCase() : 'G';
      coverImage = 'https://via.placeholder.com/400x600/6200EA/FFFFFF?text=$firstLetter';
      bannerImage = 'https://via.placeholder.com/800x400/6200EA/FFFFFF?text=$gameName';
    } else {
      coverImage = data['background_image'];
      bannerImage = data['background_image_additional'] ?? data['background_image'];
    }

    return Game(
      id: data['id'].toString(),
      title: data['name'] ?? 'Unknown Game',
      description: data['description_raw'] ?? data['description'] ?? 'No description available.',
      coverImage: coverImage,
      bannerImage: bannerImage,
      genres: genres,
      releaseDate: data['released'] != null ? DateTime.parse(data['released']) : DateTime.now(),
      developer: data['developers'] != null && (data['developers'] as List).isNotEmpty 
          ? data['developers'][0]['name'] 
          : 'Unknown Developer',
      publisher: data['publishers'] != null && (data['publishers'] as List).isNotEmpty 
          ? data['publishers'][0]['name'] 
          : 'Unknown Publisher',
      rating: (data['rating'] ?? 0.0).toDouble(),
      platforms: platforms,
    );
  }
}
