import 'package:flutter/material.dart';
import '../widgets/banner_slider.dart';
import '../widgets/brand_chip.dart';
import '../widgets/product_card.dart';
import '../data/dummy_products.dart';
import 'product_detail_screen.dart';
import '../data/dummy_brands.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedBrand = 0;
  final List<String> banners = [
    'https://images.unsplash.com/photo-1517263904808-5dc0d6e1ad43',
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
  ];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  String _searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(const Duration(seconds: 2), () {
      debugPrint('HomeScreen: 2s delay finished, mounted: '
          '{mounted}');
      if (mounted) setState(() {
        _loading = false;
        debugPrint('HomeScreen: _loading set to false');
      });
    });
    // Fallback: force loading off after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _loading) {
        setState(() {
          _loading = false;
          debugPrint('HomeScreen: Fallback loading off after 5s');
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB tapped!');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('FAB tapped!')));
        },
        child: const Icon(Icons.bug_report),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            _scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.ease);
          },
          child: Row(
            children: [
              Image.network(
                'https://cdn-icons-png.flaticon.com/512/1048/1048953.png',
                height: 32,
              ),
              const SizedBox(width: 8),
              Text('ShoeShop', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _searchFocus.requestFocus();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cart');
            },
            icon: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: _loading
          ? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                const SizedBox(height: 40),
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                const Text('Loading... If this takes long, there may be an error.'),
                // Shimmer for banner
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dummyBrands.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            )
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              controller: _scrollController,
              children: [
                BannerSlider(banners: banners),
                const SizedBox(height: 16),
                // Search bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocus,
                          decoration: const InputDecoration(
                            hintText: 'Search shoes...',
                            border: InputBorder.none,
                          ),
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Horizontal brand selector
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dummyBrands.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: BrandChip(
                        brand: dummyBrands[index],
                        selected: selectedBrand == index,
                        onTap: () {
                          setState(() => selectedBrand = index);
                          _scrollController.animateTo(210, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    _scrollController.animateTo(210, duration: const Duration(milliseconds: 400), curve: Curves.ease);
                  },
                  child: Text('Featured Shoes', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: dummyProducts
                      .where((p) => (selectedBrand == 0 || p.category == dummyBrands[selectedBrand].name) &&
                          (_searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || p.category.toLowerCase().contains(_searchQuery.toLowerCase())))
                      .length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final filtered = dummyProducts
                        .where((p) => (selectedBrand == 0 || p.category == dummyBrands[selectedBrand].name) &&
                            (_searchQuery.isEmpty || p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || p.category.toLowerCase().contains(_searchQuery.toLowerCase())))
                        .toList();
                    final product = filtered[index];
                    return Hero(
                      tag: product.imageUrl,
                      child: ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(product: product),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
