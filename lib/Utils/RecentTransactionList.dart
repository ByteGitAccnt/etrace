import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Utils/TransactionItem.dart';
import 'package:flutter/material.dart';

// only for home content
// =============================================================
// DASHBOARD TRANSACTION LIST
// PURPOSE:
// Lightweight preview list only

class RecentTransactionList extends StatelessWidget {
  final List<Transaction> transactions;

  const RecentTransactionList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),

        child: RepaintBoundary(
          child: ListView.builder(
            // =================================================
            // CRITICAL:
            // Parent ListView handles scrolling
            // =================================================
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            // =================================================
            // FIXED HEIGHT OPTIMIZATION
            // Faster than measuring each child
            // =================================================
            itemExtent: 78,

            itemCount: transactions.length,

            itemBuilder: (context, index) {
              final tx = transactions[index];

              // =============================================
              // No Slidable here
              // WHY:
              // Dashboard preview ≠ full interaction page
              // =============================================
              return TransactionItem(transaction: tx, isExpense: true);
            },
          ),
        ),
      ),
    );
  }
}
