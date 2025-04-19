import 'models.dart';

final brands = <Brand>[
  Brand(name: 'Nike', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/a/a6/Logo_NIKE.svg'),
  Brand(name: 'Adidas', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/2/20/Adidas_Logo.svg'),
  Brand(name: 'Puma', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Puma_logo.svg'),
  Brand(name: 'Reebok', imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/8/8b/Reebok_logo.svg'),
];

final products = <Product>[
  Product(
    name: 'Nike Air Max',
    brand: 'Nike',
    imageUrl: 'https://static.nike.com/a/images/t_PDP_864_v1/f_auto,q_auto:eco/1b6b2c7c-7c0d-4f99-9f8c-9c5d0b2b8d6d/air-max-90-shoes.png',
    description: 'Classic Nike comfort and style.',
    price: 139.99,
  ),
  Product(
    name: 'Adidas Ultraboost',
    brand: 'Adidas',
    imageUrl: 'https://assets.adidas.com/images/w_600,f_auto,q_auto/6b7eebd8b0d54d6e9c2eab3a010d6b10_9366/Ultraboost_21_Shoes_Black_S23869_01_standard.jpg',
    description: 'Responsive running shoes for all-day comfort.',
    price: 159.99,
  ),
  Product(
    name: 'Puma RS-X',
    brand: 'Puma',
    imageUrl: 'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa/global/369579/01/sv01/fnd/PNA/fmt/png',
    description: 'Bold style and next-level cushioning.',
    price: 119.99,
  ),
  Product(
    name: 'Reebok Classic',
    brand: 'Reebok',
    imageUrl: 'https://reebok.com.pk/cdn/shop/products/100074839_01_standard.jpg',
    description: 'A timeless classic for everyday wear.',
    price: 89.99,
  ),
];
