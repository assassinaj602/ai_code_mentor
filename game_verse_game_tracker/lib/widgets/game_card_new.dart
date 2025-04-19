import 'package:flutter/material.dart';
import '../models/game.dart';
import '../providers/game_provider.dart';
import '../screens/game_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class GameCard extends StatelessWidget {
  final Game game;
  final double height;

  const GameCard({
    super.key,
    required this.game,
    this.height = 240,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 240,
          maxHeight: 300,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameDetailScreen(game: game),
              ),
            );
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 240,
              maxHeight: 300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 16/9,
                  child: CachedNetworkImage(
                    imageUrl: game.coverImage,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                // Content
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and wishlist button
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                game.title,
                                style: Theme.of(context).textTheme.titleMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Consumer<GameProvider>(
                              builder: (context, provider, _) {
                                final isWishlisted = provider.isWishlisted(game.id);
                                return IconButton(
                                  icon: Icon(
                                    isWishlisted ? Icons.favorite : Icons.favorite_border,
                                    color: isWishlisted ? Colors.red : null,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    provider.toggleWishlist(game.id);
                                  },
                                );
                              },
                            ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
