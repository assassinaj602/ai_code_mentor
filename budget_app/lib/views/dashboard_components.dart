import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/app_provider.dart';
import '../providers/currency_provider.dart';
import 'add_transaction_form.dart';
import 'weekly_spending_chart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appProvider);

    final monthlyData = _calculateMonthlyData(state.transactions);
    final categoryData =
        _calculateCategoryData(state.transactions, state.categories);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceCard(state, context),
            const SizedBox(height: 20),
            _buildSpendingChart(monthlyData, state.transactions, context),
            const SizedBox(height: 20),
            _buildPieChart(categoryData),
            const SizedBox(height: 20),
            _buildRecentTransactions(state.transactions, context),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Export to CSV'),
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    Colors.white, // Ensures text/icon is visible on purple
                backgroundColor:
                    Theme.of(context).colorScheme.primary, // Use your purple
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: _exportData,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: const AddTransactionForm(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(appState, BuildContext context) {
    double income = appState.transactions
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    double expense = appState.transactions
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);
    double balance = income - expense;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Current Balance',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
                '${ref.watch(currencyProvider)} ${balance == 0 ? '0.00' : balance.toStringAsFixed(2)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniCard(
                    'Income',
                    '${ref.watch(currencyProvider)} ${income.toStringAsFixed(2)}',
                    Colors.green),
                _buildMiniCard(
                    'Expenses',
                    '${ref.watch(currencyProvider)} ${expense.toStringAsFixed(2)}',
                    Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniCard(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title),
        const SizedBox(height: 4),
        Text(amount,
            style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSpendingChart(Map<String, double> monthlyData, List<Transaction> transactions, BuildContext context) {
  // Only show last 4 months for simplicity
  final keys = monthlyData.keys.toList().reversed.take(4).toList().reversed.toList();
  final filteredData = {for (var k in keys) k: monthlyData[k] ?? 0};
  return Card(
    color: Theme.of(context).cardColor.withOpacity(0.97),
    elevation: 6,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => WeeklySpendingChart(transactions: transactions),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.indigo.shade400),
                    const SizedBox(width: 10),
                    Text('Monthly Trends', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const Icon(Icons.open_in_new, size: 18, color: Colors.indigo),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  barGroups: filteredData.entries
                      .map((e) => BarChartGroupData(
                            x: filteredData.keys.toList().indexOf(e.key),
                            barRods: [
                              BarChartRodData(
                                toY: e.value,
                                color: Colors.indigo,
                                width: 18,
                                borderRadius: BorderRadius.circular(6),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: filteredData.values.fold<double>(0, (prev, v) => v > prev ? v : prev),
                                  color: Colors.indigo.withOpacity(0.08),
                                ),
                              )
                            ],
                          ))
                      .toList(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (double value, TitleMeta meta) {
  final label = filteredData.keys.elementAt(value.toInt());
  // Remove year if present (e.g., 'Apr 2025' -> 'Apr')
  final month = label.split(' ').first;
  return Padding(
    padding: const EdgeInsets.only(top: 6),
    child: Text(
      month,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
  );
},
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: Colors.indigo.shade100,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${filteredData.keys.elementAt(group.x)}\n',
                          const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo),
                          children: [
                            TextSpan(
                              text: 'Spent: ${rod.toY.toStringAsFixed(2)}',
                              style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.normal),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  groupsSpace: 20,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Tap for weekly details', style: TextStyle(fontSize: 12, color: Colors.indigo.shade300)),
          ],
        ),
      ),
    ),
  );
}


  Widget _buildPieChart(Map<String, double> categoryData) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Spending by Category',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: categoryData.entries
                      .map((e) => PieChartSectionData(
                            value: e.value,
                            title: e.key,
                            color: Colors.primaries[
                                categoryData.keys.toList().indexOf(e.key) %
                                    Colors.primaries.length],
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions(
      List<Transaction> transactions, BuildContext context) {
    final recent =
        transactions.length > 5 ? transactions.sublist(0, 5) : transactions;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Transactions',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long,
                    color: Colors.indigo.shade200, size: 40),
                const SizedBox(height: 12),
                Text(
                  'No recent transactions',
                  style: TextStyle(color: Colors.indigo.shade200, fontSize: 16),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recent.length,
            itemBuilder: (context, index) {
              final t = recent[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
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
                        color: t.type == 'income' ? Colors.green : Colors.red),
                  ),
                  title: Text(t.title),
                  subtitle: Text(
                      '${t.category} • ${DateFormat('MMM d').format(t.date)}'),
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
      ],
    );
  }

  Map<String, double> _calculateMonthlyData(List<Transaction> transactions) {
    final now = DateTime.now();
    final format = DateFormat('MMM y');
    final monthlyData = <String, double>{};

    for (var i = 5; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i);
      final key = format.format(date);
      monthlyData[key] = transactions
          .where((t) => format.format(t.date) == key)
          .fold(0.0,
              (sum, t) => sum + (t.type == 'income' ? t.amount : -t.amount));
    }

    return monthlyData;
  }

  Map<String, double> _calculateCategoryData(
      List<Transaction> transactions, List<Category> categories) {
    final data = <String, double>{};
    final expenses = transactions.where((t) => t.type == 'expense');

    for (final category in categories) {
      final total = expenses
          .where((t) => t.category == category.name)
          .fold(0.0, (sum, t) => sum + t.amount);
      if (total > 0) data[category.name] = total;
    }

    return data;
  }

  Future<void> _exportData() async {
    final state = ref.read(appProvider);
    final csv = const ListToCsvConverter().convert([
      ['Date', 'Title', 'Amount', 'Category', 'Type'],
      ...state.transactions.map((t) => [
            DateFormat('yyyy-MM-dd').format(t.date),
            t.title,
            '${t.type == 'income' ? '+' : '-'}${ref.watch(currencyProvider)} ${t.amount.toStringAsFixed(2)}',
            t.category,
            t.type == 'expense' ? 'Expense' : 'Income',
          ])
    ]);

    final directory = await getDownloadsDirectory();
    if (directory != null && mounted) {
      final file = File(
          '${directory.path}/transactions_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csv);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exported to ${file.path}')),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
