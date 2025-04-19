// Product model for Zayrah E-commerce App
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final List<String> colors;
  final List<String> sizes;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.colors,
    required this.sizes,
    required this.category,
  });
}
