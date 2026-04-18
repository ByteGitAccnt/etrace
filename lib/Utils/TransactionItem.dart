import 'package:etrace/Model/Transaction.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final bool isExpense;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.isExpense = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.1),
        child: Icon(transaction.icon, color: Colors.green),
      ),
      title: Text(
        transaction.title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(transaction.date),
      trailing: Text(
        isExpense ? "- ₹${transaction.amount}" : "₹${transaction.amount}",
        style: TextStyle(
          color: isExpense ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
