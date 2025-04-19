import 'package:flutter/foundation.dart';

class TransactionModel {
  final int? id;
  final double amount;
  final String type;
  final String category;
  final String note;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.amount,
    required this.type,
    required this.category,
    this.note = '',
    required this.date,
  }) {
    if (amount <= 0) {
      throw ArgumentError('Amount must be positive');
    }
    if (type != 'expense' && type != 'income') {
      throw ArgumentError('Type must be either "expense" or "income"');
    }
    if (category.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    try {
      return TransactionModel(
        id: map['id'] as int?,
        amount: (map['amount'] as num).toDouble(),
        type: map['type'] as String,
        category: map['category'] as String,
        note: map['note'] as String,
        date: DateTime.parse(map['date'] as String),
      );
    } catch (e) {
      debugPrint('Error creating TransactionModel from map: $e');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, type: $type, category: $category, note: $note, date: $date)';
  }

  TransactionModel copyWith({
    int? id,
    double? amount,
    String? type,
    String? category,
    String? note,
    DateTime? date,
  }) {
    try {
      return TransactionModel(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        category: category ?? this.category,
        note: note ?? this.note,
        date: date ?? this.date,
      );
    } catch (e) {
      debugPrint('Error creating copy of TransactionModel: $e');
      rethrow;
    }
  }
}
