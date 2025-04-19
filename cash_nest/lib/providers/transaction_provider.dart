import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  late Database _db;
  bool _isInitialized = false;

  Future<void> initDatabase() async {
    if (_isInitialized) return;

    try {
      final String path = join(await getDatabasesPath(), 'cash_nest.db');
      _db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE transactions (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              amount REAL NOT NULL,
              type TEXT NOT NULL,
              category TEXT NOT NULL,
              note TEXT,
              date TEXT NOT NULL
            )
          ''');
        },
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await initDatabase();
      await _db.insert('transactions', transaction.toMap());
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await initDatabase();
      await _db.update(
        'transactions',
        transaction.toMap(),
        where: 'id = ?',
        whereArgs: [transaction.id],
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await initDatabase();
      await _db.delete(
        'transactions',
        where: 'id = ?',
        whereArgs: [id],
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) async {
    try {
      await initDatabase();

      String whereClause = '';
      List<dynamic> whereArgs = [];

      if (startDate != null || endDate != null || category != null) {
        whereClause = '1=1';
        if (startDate != null) {
          whereClause += ' AND date >= ?';
          whereArgs.add(startDate.toIso8601String());
        }
        if (endDate != null) {
          whereClause += ' AND date <= ?';
          whereArgs.add(endDate.toIso8601String());
        }
        if (category != null) {
          whereClause += ' AND category = ?';
          whereArgs.add(category);
        }
      }

      final List<Map<String, dynamic>> maps = await _db.query(
        'transactions',
        where: whereClause.isEmpty ? null : whereClause,
        whereArgs: whereArgs.isEmpty ? null : whereArgs,
        orderBy: 'date DESC',
      );

      return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
    } catch (e) {
      debugPrint('Error getting transactions: $e');
      rethrow;
    }
  }

  Future<double> getMonthlyExpenses({required DateTime month}) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final transactions = await getTransactions(
        startDate: startOfMonth,
        endDate: endOfMonth,
        category: null,
      );

      return transactions
          .where((t) => t.type == 'expense')
          .map((t) => t.amount)
          .reduce((sum, amount) => sum + amount);
    } catch (e) {
      debugPrint('Error getting monthly expenses: $e');
      rethrow;
    }
  }

  Future<Map<String, double>> getCategoryExpenses({required DateTime month}) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      final transactions = await getTransactions(
        startDate: startOfMonth,
        endDate: endOfMonth,
        category: null,
      );

      final Map<String, double> categoryExpenses = {};
      for (var transaction in transactions) {
        if (transaction.type == 'expense') {
          categoryExpenses.update(
            transaction.category,
            (value) => value + transaction.amount,
            ifAbsent: () => transaction.amount,
          );
        }
      }

      return categoryExpenses;
    } catch (e) {
      debugPrint('Error getting category expenses: $e');
      rethrow;
    }
  }

  Future<void> closeDatabase() async {
    try {
      await _db.close();
    } catch (e) {
      debugPrint('Error closing database: $e');
      rethrow;
    }
  }
}
