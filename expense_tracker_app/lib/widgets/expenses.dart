import 'package:expense_tracker_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

import 'package:expense_tracker_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker_app/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  
  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter course', 
      amount: 14.99, 
      date: DateTime.now(), 
      category: Category.work
    ),
    Expense(
      title: 'Cinema', 
      amount: 15.69, 
      date: DateTime.now(), 
      category: Category.leisure
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      context: context, 
      builder: (ctx) => const NewExpense()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),)
        ],
      ),
      body: Column(
        children: [
          Text('The chart'),
          Expanded(
            child: ExpensesList(expenses: _registeredExpenses),
          ),
        ],
      ),
    );
  }
}