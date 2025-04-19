import 'package:flutter/material.dart';
import 'data.dart';
import 'widgets.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: brands
          .map((brand) => ListTile(
                leading: BrandChip(brand: brand, selected: false, onTap: () {}),
                title: Text(brand.name),
                subtitle: Text(brand.country),
              ))
          .toList(),
    );
  }
}
