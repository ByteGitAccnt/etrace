import 'package:etrace/Utils/TransactionItem.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool isExpense;

  const TransactionList({
    Key? key,
    required this.transactions,
    this.isExpense = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        // Use ListView.builder for scrollability and performance
        child: ListView.builder(
          shrinkWrap:
              true, // Allows it to be used inside other scrollables if needed
          physics: const BouncingScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final tx = transactions[index];
            return TransactionItem(
              title: tx["title"],
              amount: tx["amount"],
              date: tx["date"],
              icon: tx["icon"],
              isExpense: isExpense,
            );
          },
        ),
      ),
    );
  }
}
