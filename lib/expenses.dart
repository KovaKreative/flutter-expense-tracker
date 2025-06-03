import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_widgets/expense_list.dart';
import 'package:expense_tracker/widgets/expense_widgets/new_expense.dart';
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

  void addRegisteredExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
      _registeredExpenses.sort((a, b) => a.date.isBefore(b.date) ? -1 : 1);
    });
  }

  void removeExpense(Expense expense) {
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense removed successfully!'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () => addRegisteredExpense(expense),
        ),
      ),
    );
  }

  void _openAddModal() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(addRegisteredExpense);
      },
    );
  }

  @override
  build(context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = _registeredExpenses.isNotEmpty
        ? ExpenseList(
            expenses: _registeredExpenses,
            removeExpense: removeExpense,
          )
        : Center(
            child: Text('No registered expenses. Click + above to add one!'),
          );

    final pageContent = [
      Expanded(child: Chart(expenses: _registeredExpenses)),
      Expanded(child: mainContent),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [IconButton(onPressed: _openAddModal, icon: Icon(Icons.add))],
      ),
      body: width < 600
          ? Column(children: pageContent)
          : Row(children: pageContent),
    );
  }
}
