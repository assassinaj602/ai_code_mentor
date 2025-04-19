import '../models/product_model.dart';

List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Nike Air Max 270',
    description: 'Modern running shoes with max comfort.',
    price: 129.99,
    imageUrl: 'https://images.unsplash.com/photo-1517263904808-5dc0d6e1ad43',
    rating: 4.5,
    colors: ['Red', 'Blue', 'Black'],
    sizes: ['7', '8', '9', '10'],
    category: 'Shoes',
  ),
  Product(
    id: '2',
    name: 'Amazon Echo Dot',
    description: 'Smart speaker with Alexa.',
    price: 49.99,
    imageUrl: 'https://images.unsplash.com/photo-1519125323398-675f0ddb6308',
    rating: 4.7,
    colors: ['Black', 'White'],
    sizes: [],
    category: 'Electronics',
  ),
  // Add more products as needed
];
