import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction_model.dart';
import '../config/app_config.dart';
import '../widgets/transaction_list_item.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    print('HomeScreen initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Starting database initialization');
      try {
        context.read<TransactionProvider>().initDatabase();
        print('Database initialized successfully');
      } catch (e) {
        print('Error initializing database: $e');
        debugPrint('Error initializing database: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building HomeScreen');
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Cash Nest'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConfig.primaryColor,
                      AppConfig.accentColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMonthlyChart(),
                  const SizedBox(height: 24),
                  const Text(
                    'Today’s Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTodayTransactions(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to add transaction screen
        },
        child: const Icon(Icons.add),
        backgroundColor: AppConfig.primaryColor,
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<Map<String, double>>(
          future: provider.getCategoryExpenses(month: DateTime.now()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData) {
              final data = snapshot.data!;
              final total = data.values.fold(0.0, (sum, value) => sum + value);
              final List<PieChartSectionData> sections = [];

              for (var entry in data.entries) {
                sections.add(
                  PieChartSectionData(
                    value: entry.value,
                    title: entry.key,
                    color: AppConfig.defaultCategories[entry.key] != null
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                    radius: 50,
                  ),
                );
              }

              return Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: sections,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(child: Text('No data available'));
          },
        );
      },
    );
  }

  Widget _buildTodayTransactions() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          future: provider.getTransactions(
            startDate: DateTime.now().subtract(const Duration(days: 1)),
            endDate: DateTime.now(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.hasData && snapshot.data != null) {
              final transactions = snapshot.data as List<TransactionModel>;
              if (transactions.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return TransactionListItem(
                      transaction: transaction,
                      onDelete: () {
                        try {
                          provider.deleteTransaction(transaction.id!);
                        } catch (e) {
                          debugPrint('Error deleting transaction: $e');
                        }
                      },
                    ).animate().fadeIn();
                  },
                );
              }
            }

            return const Center(child: Text('No transactions today'));
          },
        );
      },
    );
  }
}
