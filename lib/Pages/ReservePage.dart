import 'package:etrace/Utils/TransactionList.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';

class ReservePage extends StatelessWidget {
  const ReservePage({super.key});
  final List<Map<String, dynamic>> transactions = const [
    {
      "title": "Food",
      "amount": 250,
      "date": "Apr 3",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Travel",
      "amount": 120,
      "date": "Apr 2",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Food",
      "amount": 250,
      "date": "Apr 3",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Travel",
      "amount": 120,
      "date": "Apr 2",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
    {
      "title": "Shopping",
      "amount": 800,
      "date": "Apr 1",
      "icon": Icons.receipt_long,
    },
  ];
  final Color emerald = const Color(0xFF046A38);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // 👈 Aligns heading to the left
          children: [
            // --- Heading ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Reserve Funds",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),

            // --- Scrollable Transaction List ---
            Expanded(
              child: TransactionList(
                transactions: transactions.isEmpty
                    ? [
                        {
                          "title": "No Reserve funds yet",
                          "amount": 0,
                          "date": "N/A",
                          "icon": Icons.info_outline,
                        },
                      ]
                    : transactions,
                isExpense: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
