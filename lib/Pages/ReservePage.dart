import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';

class ReservePage extends StatelessWidget {
  const ReservePage({super.key});
  final List<Map<String, dynamic>> transactions = const [];
  final Color emerald = const Color(0xFF046A38);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: emerald,
      body: Center(
        child: TransactionList(
          title: "Reserved Funds",
          transactions: transactions.isEmpty
              ? [
                  {
                    "title": "No reserved funds yet",
                    "amount": 0,
                    "date": "",
                    "icon": Icons.info_outline,
                  },
                ]
              : transactions,
          isExpense: false,
        ),
      ),
    );
  }
}
