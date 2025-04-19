import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Cash Nest';
  
  static const Color primaryColor = Color(0xFF00ADB5);
  static const Color accentColor = Color(0xFFFFD369);
  static const Color darkBackground = Color(0xFF121212);
  static const Color lightBackground = Color(0xFFF5F5F5);
  
  static const Map<String, IconData> defaultCategories = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Bills': Icons.receipt,
    'Shopping': Icons.shopping_cart,
    'Entertainment': Icons.movie,
    'Health': Icons.medical_services,
    'Education': Icons.school,
    'Other': Icons.more_horiz,
  };
  
  static const List<String> defaultCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'INR',
    'JPY',
    'AUD',
    'CAD',
  ];
}
