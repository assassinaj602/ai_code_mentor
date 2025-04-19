import 'package:flutter/material.dart';
import '../data/dummy_brands.dart';
import '../widgets/brand_chip.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({Key? key}) : super(key: key);

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Brands')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(dummyBrands.length, (i) => BrandChip(
                brand: dummyBrands[i],
                selected: selected == i,
                onTap: () => setState(() => selected = i),
              )),
            ),
            const SizedBox(height: 32),
            // TODO: Show products for selected brand
            Center(child: Text('Select a brand to view shoes', style: TextStyle(fontSize: 16, color: Colors.grey[600]))),
          ],
        ),
      ),
    );
  }
}
