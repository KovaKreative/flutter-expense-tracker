import 'dart:ui';

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

    Expense newExpense = Expense(
      title: _titleController.text,
      amount: enteredAmount,
      date: _dateController,
      category: _category,
    );
    widget.addExpense(newExpense);
    Navigator.pop(context);
  }

  @override
  build(context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final titleInput = TextField(
      controller: _titleController,
      maxLength: 50,
      decoration: const InputDecoration(label: Text("Expense Name")),
      keyboardType: TextInputType.text,
    );

    final amountInput = TextField(
      controller: _amountController,
      decoration: const InputDecoration(
        prefixText: "\$",
        label: Text("Amount Spent", style: TextStyle(fontSize: 12)),
      ),
      keyboardType: TextInputType.number,
    );

    final datePicker = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(formatter.format(_dateController)),
        IconButton(
          onPressed: _openDatePicker,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    );

    final dropDown = DropdownButtonHideUnderline(
      child: DropdownButton(
        style: const TextStyle(fontSize: 12),
        value: _category,
        items: Categories.values
            .map(
              (c) =>
                  DropdownMenuItem(value: c, child: Text(c.name.toUpperCase())),
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
    );

    final controls = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Clear"),
        ),
        // const Spacer(),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _submitExpenseData,
          child: const Text("Save"),
        ),
      ],
    );

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, keyboardSpace + 20),
              child: Column(
                children: [
                  titleInput,
                  if (width > 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: amountInput),
                        const SizedBox(width: 8),
                        dropDown,
                        const SizedBox(width: 8),
                        datePicker,
                      ],
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: amountInput),
                        const SizedBox(width: 16),
                        Column(
                          children: [
                            dropDown,
                            const SizedBox(height: 8),
                            datePicker,
                          ],
                        ),
                      ],
                    ),
                  const SizedBox(height: 16),
                  controls,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
