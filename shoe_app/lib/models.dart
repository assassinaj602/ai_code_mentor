class Product {
  final String name, brand, imageUrl, description;
  final double price;
  Product({required this.name, required this.brand, required this.imageUrl, required this.description, required this.price});
}

class Brand {
  final String name, imageUrl;
  Brand({required this.name, required this.imageUrl});
}
