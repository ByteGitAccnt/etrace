import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});
  final Color emerald = const Color(0xFF046A38);

  final List<Map<String, dynamic>> transactions = const [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: emerald,
      body: Center(
        child: TransactionList(
          title: "Expenses",
          transactions: transactions.isEmpty
              ? [
                  {
                    "title": "No expenses yet",
                    "amount": 0,
                    "date": "",
                    "icon": Icons.info_outline,
                  },
                ]
              : transactions,
        ),
      ),
    );
  }
}
