import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyProvider = StateProvider<String>((ref) => 'USD'); // Default to USD
