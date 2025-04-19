import 'package:flutter/material.dart';
import '../models/brand_model.dart';

class BrandChip extends StatelessWidget {
  final Brand brand;
  final bool selected;
  final VoidCallback onTap;

  const BrandChip({Key? key, required this.brand, required this.selected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        avatar: CircleAvatar(
          backgroundImage: NetworkImage(brand.logoUrl),
        ),
        label: Text(brand.name),
        backgroundColor: selected ? Theme.of(context).colorScheme.primary : Colors.grey[200],
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
