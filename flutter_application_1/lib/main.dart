import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokéExplorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          secondary: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final List<Pokemon> _pokemon = [];
  bool _isLoading = false;
  int _offset = 0;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();
    _loadPokemon();
    _scrollController.addListener(_scrollListener);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPokemon();
    }
  }

  Future<void> _loadPokemon() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$_offset&limit=20'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        for (var pokemon in results) {
          final detailResponse = await http.get(Uri.parse(pokemon['url']));
          if (detailResponse.statusCode == 200) {
            final pokemonData = json.decode(detailResponse.body);
            setState(() {
              _pokemon.add(
                Pokemon(
                  id: pokemonData['id'],
                  name: pokemon['name'],
                  image:
                      pokemonData['sprites']['other']['official-artwork']['front_default'],
                  sprite:
                      pokemonData['sprites']['versions']['generation-v']['black-white']['animated']['front_default'] ??
                      pokemonData['sprites']['front_default'],
                  types: List<String>.from(
                    pokemonData['types'].map((type) => type['type']['name']),
                  ),
                ),
              );
            });
          }
        }

        setState(() {
          _offset += 20;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load Pokémon')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getTypeColor(String type) {
    final colors = {
      'normal': Colors.brown[300],
      'fire': Colors.red,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow,
      'ice': Colors.cyan,
      'fighting': Colors.orange[800],
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.indigo[200],
      'psychic': Colors.pink,
      'bug': Colors.lightGreen,
      'rock': Colors.grey,
      'ghost': Colors.deepPurple,
      'dragon': Colors.indigo,
      'dark': Colors.grey[800],
      'steel': Colors.blueGrey,
      'fairy': Colors.pinkAccent[100],
    };
    return colors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PokéExplorer',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
                _animationController.forward(from: 0);
              });
            },
          ),
        ],
      ),
      body: AnimationLimiter(
        child: _isGridView ? _buildGridView() : _buildListView(),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _pokemon.length + (_isLoading ? 2 : 0),
      itemBuilder: (context, index) {
        if (index >= _pokemon.length) {
          return const Center(child: CircularProgressIndicator());
        }

        return AnimationConfiguration.staggeredGrid(
          position: index,
          columnCount: 2,
          duration: const Duration(milliseconds: 500),
          child: ScaleAnimation(
            child: FadeInAnimation(child: _buildPokemonCard(_pokemon[index])),
          ),
        );
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _pokemon.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _pokemon.length) {
          return const Center(child: CircularProgressIndicator());
        }

        return AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 500),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
              child: _buildPokemonListTile(_pokemon[index]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPokemonCard(Pokemon pokemon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Image.network(
                pokemon.image,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    pokemon.name.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      for (var type in pokemon.types)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(type),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            type.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokemonListTile(Pokemon pokemon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Hero(
          tag: 'pokemon-${pokemon.id}-list',
          child: CachedNetworkImage(
            imageUrl: pokemon.sprite ?? pokemon.image,
            width: 60,
            height: 60,
            fit: BoxFit.contain,
            placeholder:
                (context, url) => const SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(child: CircularProgressIndicator()),
                ),
          ),
        ),
        title: Text(
          pokemon.name.toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            for (var type in pokemon.types)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor(type),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  type.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        trailing: Text(
          '#${pokemon.id.toString().padLeft(3, '0')}',
          style: TextStyle(
            color: Theme.of(
              context,
            ).textTheme.bodySmall?.color?.withOpacity(0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}

class Pokemon {
  final int id;
  final String name;
  final String image;
  final String sprite;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.sprite,
    required this.types,
  });
}
