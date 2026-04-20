import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final String title;
  final double amount;
  final String date;
  final IconData icon;
  bool isExpense;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
    this.isExpense = true,
  });

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    required bool isExpense,
  }) {
    return Transaction(
      id: json['id'] as int,
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      date: json['date'],
      icon: Icons.attach_money,
      isExpense: isExpense,
    );
  }

  factory Transaction.fromMap(
    Map<String, dynamic> map, {
    required bool isExpense,
  }) {
    return Transaction(
      id: map['id'] as int,
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: map['date'],
      icon: map['icon'],
      isExpense: isExpense,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'icon': icon.codePoint, // store icon as int if needed
      'isExpense': isExpense,
    };
  }
}
