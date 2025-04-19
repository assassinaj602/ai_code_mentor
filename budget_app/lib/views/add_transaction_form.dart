import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/transaction.dart';
import '../providers/app_provider.dart';

class AddTransactionForm extends ConsumerStatefulWidget {
  const AddTransactionForm({super.key});

  @override
  ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedType = 'expense';
  Category? _selectedCategory;

  // Category list as a class field
  final List<Category> categories = [
    Category(id: 'food', name: 'Food', icon: Icons.restaurant, color: Colors.orange),
    Category(id: 'transport', name: 'Transport', icon: Icons.directions_car, color: Colors.purple),
    Category(id: 'shopping', name: 'Shopping', icon: Icons.shopping_bag, color: Colors.pink),
    Category(id: 'bills', name: 'Bills', icon: Icons.receipt, color: Colors.red),
    Category(id: 'other_expense', name: 'Other Expense', icon: Icons.money_off, color: Colors.grey),
    Category(id: 'salary', name: 'Salary', icon: Icons.attach_money, color: Colors.indigo),
    Category(id: 'gift', name: 'Gift', icon: Icons.card_giftcard, color: Colors.green),
    Category(id: 'other_income', name: 'Other Income', icon: Icons.monetization_on, color: Colors.blue),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            TextFormField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: ['income', 'expense']
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.capitalize()),
                      ))
                  .toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              hint: const Text('Select Category'),
              items: [
                ...categories.map((category) => DropdownMenuItem<Category>(
                  key: ValueKey(category.id),
                  value: category,
                  child: Row(
                    children: [
                      Icon(category.icon),
                      const SizedBox(width: 8),
                      Text(category.name),
                    ],
                  ),
                )),
              ],
              onChanged: (value) async {
                if (value == null) {
                  // Show dialog to add new category
                  final newCategory = await showDialog<Category>(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          final catNameController = TextEditingController();
                          IconData? selectedIcon;
                          return AlertDialog(
                            title: const Text('Add Category'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: catNameController,
                                    decoration: const InputDecoration(labelText: 'Category Name'),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      for (final icon in [
                                        Icons.restaurant,
                                        Icons.directions_car,
                                        Icons.shopping_bag,
                                        Icons.receipt,
                                        Icons.money_off,
                                        Icons.attach_money,
                                        Icons.card_giftcard,
                                        Icons.monetization_on,
                                      ])
                                        GestureDetector(
                                          onTap: () => setState(() => selectedIcon = icon),
                                          child: CircleAvatar(
                                            backgroundColor: selectedIcon == icon ? Colors.indigo : Colors.grey.shade200,
                                            child: Icon(icon, color: selectedIcon == icon ? Colors.white : Colors.black),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  catNameController.dispose();
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  final name = catNameController.text.trim();
                                  if (name.isEmpty || selectedIcon == null) return;
                                  final exists = categories.any((cat) => cat.name.toLowerCase() == name.toLowerCase());
                                  if (exists) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Category already exists.')),
                                    );
                                    return;
                                  }
                                  final cat = Category(
                                    id: name.toLowerCase().replaceAll(' ', '_'),
                                    name: name,
                                    icon: selectedIcon!,
                                    color: Colors.grey,
                                  );
                                  catNameController.dispose();
                                  Navigator.pop(context, cat);
                                },
                                child: const Text('Add'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                  if (newCategory != null) {
                    setState(() {
                      categories.add(newCategory);
                      _selectedCategory = newCategory;
                    });
                  }
                } else {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            ListTile(
              title: Text(DateFormat.yMd().format(_selectedDate)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
            ),
            ValueListenableBuilder(
              valueListenable: _titleController,
              builder: (context, _, __) {
                final isEnabled = _titleController.text.trim().isNotEmpty &&
                    _amountController.text.trim().isNotEmpty &&
                    _selectedCategory != null;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isEnabled ? Colors.indigo : Colors.grey,
                    foregroundColor: isEnabled ? Colors.white : Colors.black,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: isEnabled
                      ? () {
                          // Check for null before using _formKey.currentState
                          final formState = _formKey.currentState;
                          if (formState != null && formState.validate()) {
                            double? amount;
                            try {
                              amount = double.parse(_amountController.text);
                            } catch (_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Enter a valid amount.')),
                              );
                              return;
                            }
                            ref.read(appProvider.notifier).addTransaction(
                              Transaction(
                                id: DateTime.now().toString(),
                                title: _titleController.text,
                                amount: amount,
                                date: _selectedDate,
                                category: _selectedCategory?.name ?? 'Uncategorized',
                                type: _selectedType,
                                note: _noteController.text,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      : null,
                  child: const Text('Add Transaction'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}
