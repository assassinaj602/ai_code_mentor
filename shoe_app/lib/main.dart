import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'brands_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

void main() {
  runApp(const ShoeShopApp());
}

class ShoeShopApp extends StatelessWidget {
  const ShoeShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartProvider())],
      child: MaterialApp(
        title: 'Shoe Shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainShell(),
      ),
    );
  }
}

// --- Cart Provider ---
class CartProvider extends ChangeNotifier {
  final List<Product> _cart = [];
  List<Product> get cart => List.unmodifiable(_cart);
  void add(Product p) {
    _cart.add(p);
    notifyListeners();
  }

  void remove(Product p) {
    _cart.remove(p);
    notifyListeners();
  }
}

// --- Product Model (Simple) ---
class Product {
  final String name, brand, imageUrl, description;
  final double price;
  Product({
    required this.name,
    required this.brand,
    required this.imageUrl,
    required this.description,
    required this.price,
  });
}

// --- Main Shell with Bottom Navigation ---
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final screens = [HomeScreen(), BrandsScreen(), CartScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Brands'),
          NavigationDestination(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// --- HomeScreen ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedBrand = 0;
  String _search = '';
  final _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filtered =
        products.where((p) {
          final brandOk =
              selectedBrand == 0 || p.brand == brands[selectedBrand - 1].name;
          final searchOk =
              _search.isEmpty ||
              p.name.toLowerCase().contains(_search.toLowerCase()) ||
              p.brand.toLowerCase().contains(_search.toLowerCase());
          return brandOk && searchOk;
        }).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Banner
        Container(
          height: 140,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: NetworkImage(
                'https://images.unsplash.com/photo-1517263904808-5dc0d6e1ad43',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Search
        TextField(
          controller: _searchCtrl,
          decoration: InputDecoration(
            hintText: 'Search shoes or brands...',
            prefixIcon: Icon(Icons.search),
            suffixIcon:
                _search.isNotEmpty
                    ? IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _search = '';
                          _searchCtrl.clear();
                        });
                      },
                    )
                    : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
          onChanged: (val) => setState(() => _search = val),
        ),
        const SizedBox(height: 16),
        // Brands
        SizedBox(
          height: 48,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length + 1,
            itemBuilder:
                (context, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child:
                      i == 0
                          ? ChoiceChip(
                            label: const Text('All'),
                            selected: selectedBrand == 0,
                            onSelected:
                                (_) => setState(() => selectedBrand = 0),
                          )
                          : BrandChip(
                            brand: brands[i - 1],
                            selected: selectedBrand == i,
                            onTap: () => setState(() => selectedBrand = i),
                          ),
                ),
          ),
        ),
        const SizedBox(height: 16),
        // Products
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemBuilder:
              (context, i) => Hero(
                tag: filtered[i].imageUrl,
                child: ProductCard(
                  product: filtered[i],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => ProductDetailScreen(product: filtered[i]),
                      ),
                    );
                  },
                ),
              ),
        ),
      ],
    );
  }
}

// --- BrandsScreen ---
class BrandsScreen extends StatelessWidget {
  const BrandsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children:
          brands
              .map(
                (b) => Card(
                  child: ListTile(
                    leading: Image.network(b.imageUrl, height: 32),
                    title: Text(b.name),
                  ),
                ),
              )
              .toList(),
    );
  }
}

// --- CartScreen ---

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context).cart;
    return cart.isEmpty
        ? Center(child: Text('Your cart is empty'))
        : ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: cart.length,
          separatorBuilder: (_, __) => Divider(),
          itemBuilder:
              (context, i) => ListTile(
                leading: Image.network(cart[i].imageUrl, height: 48),
                title: Text(cart[i].name),
                subtitle: Text(cart[i].brand),
                trailing: Text('\$${cart[i].price.toStringAsFixed(2)}'),
                onLongPress: () => Provider.of<CartProvider>(context, listen: false).remove(cart[i]),
              ),
        );
  }
}

// --- ProfileScreen ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile (coming soon)', style: TextStyle(fontSize: 20)),
    );
  }
}
