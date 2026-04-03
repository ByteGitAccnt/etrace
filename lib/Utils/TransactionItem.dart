import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final int amount;
  final String date;
  final IconData icon;
  final bool isExpense;

  const TransactionItem({
    Key? key,
    required this.title,
    required this.amount,
    required this.date,
    required this.icon,
    required this.isExpense,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green.withOpacity(0.1),
        child: Icon(icon, color: Colors.green),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(date),
      trailing: Text(
        isExpense ? "- ₹$amount" : "₹$amount",
        style: TextStyle(
          color: isExpense ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
