import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/game_card.dart';
import '../widgets/loading_indicator.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(BuildContext context) {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      
      Provider.of<GameProvider>(context, listen: false)
          .searchGames(query)
          .then((_) {
        setState(() {
          _isSearching = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);
    final searchResults = gameProvider.searchResults;
    final isLoading = gameProvider.isLoading;
    final errorMessage = gameProvider.errorMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Games'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for games...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              style: const TextStyle(color: Colors.black87),
              onSubmitted: (_) => _performSearch(context),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          if (_searchController.text.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'Search for your favorite games',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else if (isLoading || _isSearching)
            const Expanded(
              child: Center(
                child: LoadingIndicator(message: 'Searching games...'),
              ),
            )
          else if (errorMessage.isNotEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else if (searchResults.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No games found. Try a different search term.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return GameCard(game: searchResults[index]);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
