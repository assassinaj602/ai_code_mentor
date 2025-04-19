import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import '../models/movie.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';
import '../widgets/cached_image_widget.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final ApiService _apiService = ApiService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Netflix'),
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Movie>>(
              future: _apiService.getTrendingMovies(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  return SizedBox(
                    height: 400,
                    child: CarouselSlider(
                      slideTransform: const CubeTransform(),
                      slideIndicator: CircularSlideIndicator(
                        padding: const EdgeInsets.only(bottom: 32),
                        currentIndicatorColor: Colors.white,
                      ),
                      children:
                          snapshot.data!.map((movie) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            MovieDetailScreen(movie: movie),
                                  ),
                                );
                              },
                              child: CachedImage(
                                imageUrl:
                                    movie.backdropPath.isNotEmpty
                                        ? 'https://image.tmdb.org/t/p/w1280${movie.backdropPath}'
                                        : 'https://via.placeholder.com/400x600',
                              ),
                            );
                          }).toList(),
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Popular Movies',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            FutureBuilder<List<Movie>>(
              future: _apiService.getPopularMovies(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (snapshot.hasData) {
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final movie = snapshot.data![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          MovieDetailScreen(movie: movie),
                                ),
                              );
                            },
                            child: CachedImage(
                              imageUrl:
                                  movie.posterPath.isNotEmpty
                                      ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                      : 'https://via.placeholder.com/130x200',
                              width: 130,
                              height: 200,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
