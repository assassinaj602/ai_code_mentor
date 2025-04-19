import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String search = '';
  String? selectedBrand;

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((p) {
      final matchesBrand = selectedBrand == null || p.brand == selectedBrand;
      final matchesSearch = p.name.toLowerCase().contains(search.toLowerCase()) ||
          p.brand.toLowerCase().contains(search.toLowerCase());
      return matchesBrand && matchesSearch;
    }).toList();
    return ListView(
      children: [
        // Banner slider (placeholder)
        SizedBox(
          height: 160,
          child: PageView(
            children: [
              Image.network('https://images.unsplash.com/photo-1517263904808-5dc0d6c3d43c', fit: BoxFit.cover),
              Image.network('https://images.unsplash.com/photo-1519864600265-abb23847ef2c', fit: BoxFit.cover),
            ],
          ),
        ),
        // Search bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for shoes or brands',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onChanged: (value) => setState(() => search = value),
          ),
        ),
        // Brands horizontal list
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            separatorBuilder: (_, __) => SizedBox(width: 8),
            itemBuilder: (context, i) => BrandChip(
              brand: brands[i],
              selected: selectedBrand == brands[i].name,
              onTap: () => setState(() => selectedBrand = brands[i].name == selectedBrand ? null : brands[i].name),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Products grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: filteredProducts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, i) => ProductCard(
              product: filteredProducts[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: filteredProducts[i]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
