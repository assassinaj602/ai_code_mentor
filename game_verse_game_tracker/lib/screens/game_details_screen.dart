import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game.dart';
import '../models/review.dart';
import '../providers/game_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/rating_bar.dart';
import '../widgets/progress_tracker.dart';

class GameDetailsScreen extends StatelessWidget {
  final Game game;

  const GameDetailsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                game.bannerImage,
                fit: BoxFit.cover,
              ),
              title: Text(game.title),
            ),
            actions: [
              Consumer<GameProvider>(
                builder: (context, provider, _) {
                  final isWishlisted = provider.isWishlisted(game.id);
                  return IconButton(
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                      color: isWishlisted ? Colors.red : null,
                    ),
                    onPressed: () => provider.toggleWishlist(game.id),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Consumer<ReviewProvider>(
                        builder: (context, provider, _) {
                          final rating = provider.getAverageRating(game.id);
                          return GameRatingBar(rating: rating);
                        },
                      ),
                      const SizedBox(width: 8),
                      Consumer<ReviewProvider>(
                        builder: (context, provider, _) {
                          final reviews = provider.getReviewsForGame(game.id);
                          return Text(
                            '(${reviews.length} reviews)',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(game.description),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...game.genres.map(
                        (genre) => Chip(
                          label: Text(genre),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Release Date'),
                    subtitle: Text(
                      '${game.releaseDate.day}/${game.releaseDate.month}/${game.releaseDate.year}',
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.developer_board),
                    title: const Text('Developer'),
                    subtitle: Text(game.developer),
                  ),
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text('Publisher'),
                    subtitle: Text(game.publisher),
                  ),
                  ListTile(
                    leading: const Icon(Icons.gamepad),
                    title: const Text('Platforms'),
                    subtitle: Text(game.platforms.join(', ')),
                  ),
                  const SizedBox(height: 24),
                  ProgressTracker(gameId: game.id),
                  const SizedBox(height: 24),
                  Text(
                    'Reviews',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Consumer<ReviewProvider>(
                    builder: (context, provider, _) {
                      final reviews = provider.getReviewsForGame(game.id);
                      return Column(
                        children: [
                          ElevatedButton(
                            onPressed: () => _showAddReviewDialog(context),
                            child: const Text('Write a Review'),
                          ),
                          const SizedBox(height: 16),
                          ...reviews.map((review) => _buildReviewCard(review)),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameRatingBar(rating: review.rating),
            const SizedBox(height: 8),
            Text(review.comment),
            const SizedBox(height: 8),
            Text(
              'Posted on ${review.datePosted.day}/${review.datePosted.month}/${review.datePosted.year}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReviewDialog(BuildContext context) {
    double rating = 0;
    String comment = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Write a Review'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GameRatingBar(
              rating: rating,
              isInteractive: true,
              onRatingUpdate: (value) => rating = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Write your review here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => comment = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (rating > 0 && comment.isNotEmpty) {
                final review = Review(
                  gameId: game.id,
                  rating: rating,
                  comment: comment,
                  datePosted: DateTime.now(),
                );
                context.read<ReviewProvider>().addReview(review);
                Navigator.pop(context);
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
