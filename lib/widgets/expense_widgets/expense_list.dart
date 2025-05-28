import 'package:expense_tracker/widgets/expense_widgets/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(this.expenses, {super.key});

  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, i) => ExpenseItem(expenses[i]),
    );
  }
}
