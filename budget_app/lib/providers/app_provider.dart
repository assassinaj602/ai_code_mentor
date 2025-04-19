import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/category.dart';
import '../models/transaction.dart';

class AppState {
  final ThemeMode themeMode;
  final List<Transaction> transactions;
  final List<Category> categories;

  const AppState({
    this.themeMode = ThemeMode.system,
    this.transactions = const [],
    this.categories = const [],
  });

  AppState copyWith({
    ThemeMode? themeMode,
    List<Transaction>? transactions,
    List<Category>? categories,
  }) {
    return AppState(
      themeMode: themeMode ?? this.themeMode,
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier() : super(const AppState());

  void toggleTheme() {
    state = state.copyWith(
      themeMode: state.themeMode == ThemeMode.light 
          ? ThemeMode.dark 
          : ThemeMode.light,
    );
  }

  Future<void> loadData() async {
    final transactionsBox = await Hive.openBox<Transaction>('transactions');
    final categoriesBox = await Hive.openBox<Category>('categories');
    
    state = state.copyWith(
      transactions: transactionsBox.values.toList(),
      categories: categoriesBox.values.toList(),
    );
  }

  Future<void> addTransaction(Transaction transaction) async {
    final box = await Hive.openBox<Transaction>('transactions');
    await box.add(transaction);
    
    state = state.copyWith(
      transactions: [...state.transactions, transaction],
    );
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier();
});
