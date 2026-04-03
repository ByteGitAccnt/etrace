import 'package:etrace/Utils/TransactionItem.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> transactions;
  final bool isExpense;

  const TransactionList({
    Key? key,
    required this.title,
    required this.transactions,
    this.isExpense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Transaction List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: transactions.map((tx) {
                return TransactionItem(
                  title: tx["title"],
                  amount: tx["amount"],
                  date: tx["date"],
                  icon: tx["icon"],
                  isExpense: isExpense,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
