import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../utils/constants.dart';

class ApiService {
  final _client = http.Client();
  static const _timeout = Duration(seconds: 15);

  Future<List<Movie>> getTrendingMovies() async {
    try {
      developer.log('Fetching trending movies...');
      final url =
          '${ApiConstants.baseUrl}/trending/movie/day?api_key=${ApiConstants.apiKey}';
      developer.log('URL: $url');

      final response = await _client
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(_timeout);

      developer.log('Response status: ${response.statusCode}');
      developer.log(
        'Response body: ${response.body.substring(0, 100)}...',
      ); // Log first 100 chars

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movies =
            (data['results'] as List)
                .map((movie) => Movie.fromJson(movie))
                .toList();
        developer.log('Successfully parsed ${movies.length} movies');
        return movies;
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      developer.log('Network error: $e');
      throw Exception('Please check your internet connection');
    } on FormatException catch (e) {
      developer.log('Data parsing error: $e');
      throw Exception('Unable to process the data');
    } catch (e) {
      developer.log('Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    try {
      developer.log('Fetching popular movies...');
      final url =
          '${ApiConstants.baseUrl}/movie/popular?api_key=${ApiConstants.apiKey}';
      developer.log('URL: $url');

      final response = await _client
          .get(Uri.parse(url), headers: {'Accept': 'application/json'})
          .timeout(_timeout);

      developer.log('Response status: ${response.statusCode}');
      developer.log(
        'Response body: ${response.body.substring(0, 100)}...',
      ); // Log first 100 chars

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final movies =
            (data['results'] as List)
                .map((movie) => Movie.fromJson(movie))
                .toList();
        developer.log('Successfully parsed ${movies.length} movies');
        return movies;
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      developer.log('Network error: $e');
      throw Exception('Please check your internet connection');
    } on FormatException catch (e) {
      developer.log('Data parsing error: $e');
      throw Exception('Unable to process the data');
    } catch (e) {
      developer.log('Unexpected error: $e');
      throw Exception('An unexpected error occurred');
    }
  }
}
