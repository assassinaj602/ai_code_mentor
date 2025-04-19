import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/app_provider.dart';
import '../providers/currency_provider.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appProvider);
    final transactions = state.transactions;
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long,
                      color: Colors.indigo.shade200, size: 56),
                  const SizedBox(height: 16),
                  Text('No transactions yet',
                      style: TextStyle(
                          color: Colors.indigo.shade200, fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.indigo.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        t.type == 'income'
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: t.type == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(t.title),
                    subtitle: Text(
                        '${t.category} • ${DateFormat('MMM d, yyyy').format(t.date)}'),
                    trailing: Text(
                      '${t.type == 'income' ? '+' : '-'}${ref.watch(currencyProvider)} ${t.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: t.type == 'income' ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
