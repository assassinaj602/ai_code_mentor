import 'package:flutter/material.dart';
import '../models/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;
  
  const GameDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banner image
            AspectRatio(
              aspectRatio: 16/9,
              child: game.bannerImage.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: game.bannerImage,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    game.bannerImage,
                    fit: BoxFit.cover,
                  ),
            ),
            // Game details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover image and basic info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover image
                      Container(
                        width: 120,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: game.coverImage.startsWith('http')
                            ? CachedNetworkImage(
                                imageUrl: game.coverImage,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                game.coverImage,
                                fit: BoxFit.cover,
                              ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Basic info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rating: ${game.rating}/5',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Released: ${game.releaseDate.year}-${game.releaseDate.month}-${game.releaseDate.day}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Platforms: ${game.platforms.join(', ')}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Publisher: ${game.publisher}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  // Genres
                  Text(
                    'Genres',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: game.genres.map((genre) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6A00F4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        genre,
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
