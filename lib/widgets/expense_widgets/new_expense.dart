import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat('dd-MM-yyyy');

class NewExpense extends StatefulWidget {
  const NewExpense(this.addExpense, {super.key});

  final void Function(Expense expense) addExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _dateController = DateTime.now();
  Categories _category = Categories.food;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _openDatePicker() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1, now.month, now.day);
    final last = DateTime(now.year + 1, now.month, now.day);
    final newDate = await showDatePicker(
      context: context,
      initialDate: _dateController,
      firstDate: first,
      lastDate: last,
    );

    if (newDate == null) {
      return;
    }
    setState(() {
      _dateController = newDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);

    bool invalid =
        _titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount <= 0;

    if (invalid) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please enter valid title and amount"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    Expense newExpense = Expense(title: _titleController.text, amount: enteredAmount, date: _dateController, category: _category);
    widget.addExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  build(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Expense Name")),
            keyboardType: TextInputType.text,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    prefixText: "\$",
                    label: Text("Amount Spent", style: TextStyle(fontSize: 16)),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(formatter.format(_dateController)),
                    IconButton(
                      onPressed: _openDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              DropdownButton(
                style: TextStyle(fontSize: 12, color: Colors.black),
                value: _category,
                items: Categories.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name.toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _category = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Clear"),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
