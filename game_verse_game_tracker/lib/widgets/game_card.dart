import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/game_detail_screen.dart';

class GameCard extends StatelessWidget {
  final Game game;
  
  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GameDetailScreen(game: game),
            ),
          );
        },
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Section
                AspectRatio(
                  aspectRatio: 16/9,
                  child: _buildGameImage(),
                ),
                
                // Content Section
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              game.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // GameRatingBar(rating: game.rating, isInteractive: false),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Developer
                      Text(
                        game.developer,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Genres
                      SizedBox(
                        height: 28,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: game.genres.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 4, top: 4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF6A00F4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                game.genres[index],
                                style: GoogleFonts.orbitron(
                                  fontSize: 9,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Wishlist Button
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  gameProvider.isWishlisted(game.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  gameProvider.toggleWishlist(game.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameImage() {
    // Check if image is a network URL
    if (game.coverImage.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: game.coverImage,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: CircularProgressIndicator(
            value: progress.progress,
          ),
        ),
        errorWidget: (context, url, error) => _buildFallbackImage(),
      );
    }
    
    // Try loading as asset
    try {
      return Image.asset(
        game.coverImage,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(),
      );
    } catch (e) {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_esports, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              game.title[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
