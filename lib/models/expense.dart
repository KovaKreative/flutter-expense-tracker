import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();

final formatter = DateFormat('dd-MM-yyyy');

enum Categories { food, travel, entertainment, electronics }

const categoryIcons = {
  Categories.food: Icons.lunch_dining,
  Categories.travel: Icons.emoji_transportation,
  Categories.entertainment: Icons.local_movies,
  Categories.electronics: Icons.computer,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Categories category;

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  const ExpenseBucket({required this.cat, required this.expenses});

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.cat)
    : expenses = allExpenses.where((e) => e.category == cat).toList();

  final Categories cat;
  final List<Expense> expenses;

  double get totalExpenses {
    if (expenses.isEmpty) {
      return 0;
    }
    return expenses.map((e) => e.amount).reduce((v, e) => v + e);
  }
}
