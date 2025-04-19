import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: Consumer<GameProvider>(
        builder: (context, provider, _) {
          final wishlistedGames = provider.wishlistedGames;
          final isLoading = provider.isLoading;

          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (wishlistedGames.isEmpty) {
            return const Center(
              child: Text('Your wishlist is empty'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: wishlistedGames.length,
            itemBuilder: (context, index) {
              final game = wishlistedGames[index];
              return GameCard(game: game);
            },
          );
        },
      ),
    );
  }
}
