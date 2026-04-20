import 'package:etrace/Notifiers/TransactionNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservePage extends ConsumerWidget {
  const ReservePage({super.key});

  final Color emerald = const Color(0xFF046A38);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionProvider);

    // ✅ Only reserve items (non-expense)
    final reserveList = state.items.where((t) => !t.isExpense).toList();

    return Scaffold(
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            Expanded(
              child: reserveList.isEmpty
                  ? const Center(
                      child: Text(
                        "No reserve transactions",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : TransactionList(
                      transactions: reserveList,
                      isExpense: false,

                      onDelete: (tx, index) {
                        final notifier = ref.read(transactionProvider.notifier);

                        // ✅ Always delete by ID
                        notifier.deleteById(tx.id);

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: const Text("Item deleted"),
                              duration: const Duration(seconds: 3),
                              action: SnackBarAction(
                                label: "UNDO",
                                onPressed: notifier.undo,
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





/* import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:etrace/Notifiers/TransactionNotifier_old.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservePage extends ConsumerWidget {
  const ReservePage({super.key});

  final Color emerald = const Color(0xFF046A38);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactions = ref.watch(transactionProvider);

    final reserveList = allTransactions.toList();

    return Scaffold(
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            Expanded(
              child: TransactionList(
                transactions: reserveList.isEmpty
                    ? [
                        Transaction(
                          id: 0,
                          title: "No transactions yet",
                          amount: 0.0,
                          date: "",
                          icon: Icons.info_outline,
                        ),
                      ]
                    : reserveList,
                isExpense: false,

                // DELETE
                onDelete: (tx, index) {
                  final notifier = ref.read(transactionProvider.notifier);
                  final messenger = ScaffoldMessenger.of(context);

                  //  Trigger delete (starts timer inside notifier)
                  notifier.deleteById(index);

                  //  Remove any existing snackbar (prevents stacking bugs)
                  messenger.hideCurrentSnackBar();

                  final snackBar = SnackBar(
                    content: const Text("Item deleted"),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: "UNDO",
                      onPressed: () {
                        notifier.undo();
                      },
                    ),
                  );

                  // Show snackbar
                  messenger.showSnackBar(snackBar);

                  //  Force sync with your 3s undo window
                  Future.delayed(const Duration(seconds: 3), () {
                    messenger.hideCurrentSnackBar();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
 */