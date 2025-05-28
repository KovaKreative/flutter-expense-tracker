import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expenseItem, {super.key});

  final Expense expenseItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(expenseItem.title),
            Row(
              children: [
                Text(
                  '\$${expenseItem.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 10),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(Icons.shop),
                    Text(
                      expenseItem.date.toString(),
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
