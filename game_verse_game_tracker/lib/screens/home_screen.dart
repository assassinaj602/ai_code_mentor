import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game.dart';
import '../widgets/game_card.dart';
import '../widgets/loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  // Build genre filter chips
  Widget _buildGenreFilter() {
    // Get unique genres from all games
    final allGenres = Provider.of<GameProvider>(context, listen: false)
        .games
        .expand((game) => game.genres)
        .toSet()
        .toList();
    
    // Sort genres alphabetically
    allGenres.sort();
    
    // Create a list of genre chips
    final genreChips = [
      _buildGenreChip('All', _selectedGenre == null),
      ...allGenres.map((genre) => _buildGenreChip(genre, _selectedGenre == genre)),
    ];
    
    return ListView(
      scrollDirection: Axis.horizontal,
      children: genreChips,
    );
  }
  
  // Build individual genre chip
  Widget _buildGenreChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.orbitron(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        selectedColor: const Color(0xFF34C759), // Lime green
        backgroundColor: const Color(0xFF2D2D44), // Dark navy
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onSelected: (selected) {
          setState(() {
            _selectedGenre = selected ? (label == 'All' ? null : label) : null;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        toolbarHeight: 0,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Games'),
            Tab(text: 'Popular'),
            Tab(text: 'New Releases'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All Games Tab
          _buildGamesTab(context, 'all'),
          
          // Popular Games Tab
          _buildGamesTab(context, 'popular'),
          
          // New Releases Tab
          _buildGamesTab(context, 'new'),
        ],
      ),
    );
  }
  
  Widget _buildGamesTab(BuildContext context, String tabType) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, _) {
        final isLoading = gameProvider.isLoading;
        final errorMessage = gameProvider.errorMessage;
        
        // Get base games list
        List<Game> filteredGames = gameProvider.games;
        
        // Apply genre filter if needed
        if (_selectedGenre != null) {
          filteredGames = filteredGames.where((game) {
            // Case insensitive genre matching
            return game.genres.any((genre) => 
              genre.toLowerCase() == _selectedGenre!.toLowerCase() ||
              genre.toLowerCase().contains(_selectedGenre!.toLowerCase()) ||
              _selectedGenre!.toLowerCase().contains(genre.toLowerCase())
            );
          }).toList();
        }
        
        // Apply different filters based on tab
        if (tabType == 'popular') {
          filteredGames = filteredGames.where((game) => game.rating >= 4.0).toList();
        } else if (tabType == 'new') {
          // Filter games released in the last year
          final oneYearAgo = DateTime.now().subtract(const Duration(days: 365));
          filteredGames = filteredGames.where((game) => game.releaseDate.isAfter(oneYearAgo)).toList();
        }
        
        // Apply search filter if needed
        if (_searchQuery.isNotEmpty) {
          filteredGames = gameProvider.filterGames(_searchQuery);
        }
        
        if (isLoading) {
          return const Center(
            child: LoadingIndicator(message: 'Loading games...'),
          );
        }
        
        if (errorMessage.isNotEmpty && gameProvider.games.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading games using the public method
                    Provider.of<GameProvider>(context, listen: false)
                        .loadGames();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search games...',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                ),
                style: const TextStyle(color: Colors.black87),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            
            // Genre filters
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildGenreFilter(),
              ),
            ),
            
            // Games grid
            Expanded(
              child: filteredGames.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.videogame_asset_off,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No games found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: filteredGames.length,
                      itemBuilder: (context, index) {
                        return GameCard(game: filteredGames[index]);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
