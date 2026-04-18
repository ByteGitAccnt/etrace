import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:etrace/Utils/TransactionNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensePage extends ConsumerWidget {
  const ExpensePage({super.key});

  final Color emerald = const Color(0xFF046A38);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactions = ref.watch(transactionProvider);

    final expenseList = allTransactions.toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: emerald,
        elevation: 0,
        title: const Text(
          "Expense list",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TransactionList(
                transactions: expenseList.isEmpty
                    ? [
                        Transaction(
                          id: 0,
                          title: "No expenses yet",
                          amount: 0,
                          date: "",
                          icon: Icons.info_outline,
                        ),
                      ]
                    : expenseList,

                // 🔴 DELETE
                onDelete: (tx, index) {
                  ref.read(transactionProvider.notifier).delete(index);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Item deleted"),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          ref.read(transactionProvider.notifier).undo();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
