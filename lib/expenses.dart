import 'package:expense_tracker/widgets/expense_widgets/expense_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
      title: "Drawing Tablet",
      amount: 300,
      date: DateTime.now(),
      category: Categories.electronics,
    ),
    Expense(
      title: "Groceries",
      amount: 29.84,
      date: DateTime.now(),
      category: Categories.food,
    ),
    Expense(
      title: "Presto Refill",
      amount: 20,
      date: DateTime.now(),
      category: Categories.travel,
    ),
  ];

  @override
  build(context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Chart'),
          Expanded(child: ExpenseList(_registeredExpenses)),
        ],
      ),
    );
  }
}
