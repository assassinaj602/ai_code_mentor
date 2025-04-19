import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/transaction_model.dart';
import '../config/app_config.dart';
import 'package:flutter/foundation.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  IconData _getCategoryIcon(String category) {
    try {
      final icon = AppConfig.defaultCategories[category];
      return icon ?? Icons.category;
    } catch (e) {
      debugPrint('Error getting category icon: $e');
      return Icons.category;
    }
  }

  Color _getTransactionColor(String type) {
    try {
      return type == 'expense' ? Colors.red : Colors.green;
    } catch (e) {
      debugPrint('Error getting transaction color: $e');
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getTransactionColor(transaction.type).withOpacity(0.2),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: _getTransactionColor(transaction.type),
            ),
          ),
          title: Text(
            transaction.category,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            transaction.note,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                transaction.type == 'expense'
                    ? '-\$${transaction.amount.toStringAsFixed(2)}'
                    : '+\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _getTransactionColor(transaction.type),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  try {
                    onDelete();
                  } catch (e) {
                    debugPrint('Error deleting transaction: $e');
                  }
                },
              ),
            ],
          ),
        ),
      ).animate().fadeIn();
    } catch (e) {
      debugPrint('Error building TransactionListItem: $e');
      return const Card(
        child: ListTile(
          title: Text('Error displaying transaction'),
        ),
      );
    }
  }
}
