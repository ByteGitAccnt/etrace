import 'package:flutter/material.dart';

class Transaction {
  final int id;
  final String title;
  final double amount;
  final String date;
  final IconData icon;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as int,
      title: json['title'],
      amount: (json['amount'] as num).toDouble(),
      date: json['date'],
      icon: Icons.attach_money,
    );
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int,
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: map['date'],
      icon: map['icon'],
    );
  }
}
