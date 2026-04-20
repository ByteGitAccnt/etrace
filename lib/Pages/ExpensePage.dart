import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Notifiers/SearchNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:etrace/Notifiers/TransactionNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensePage extends ConsumerStatefulWidget {
  const ExpensePage({super.key});

  @override
  ConsumerState<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends ConsumerState<ExpensePage> {
  final Color emerald = const Color(0xFF046A38);

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(searchProvider.notifier).fetchMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: emerald,
        title: const Text("Search Results"),
      ),
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TransactionList(
                transactions: searchState.results,
                enableDelete: true, // ✅ now enabled

                controller: _scrollController,

                onDelete: (tx, index) {
                  final txnNotifier = ref.read(transactionProvider.notifier);
                  final searchNotifier = ref.read(searchProvider.notifier);

                  // ✅ delete from BOTH
                  txnNotifier.deleteById(tx.id);
                  searchNotifier.removeById(tx.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Item deleted"),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          final txnNotifier = ref.read(
                            transactionProvider.notifier,
                          );
                          final searchNotifier = ref.read(
                            searchProvider.notifier,
                          );

                          // ✅ capture BEFORE undo
                          final last = txnNotifier.lastDeleted;

                          txnNotifier.undo();

                          if (last != null) {
                            searchNotifier.addBack(last);
                          }
                          /*   txnNotifier.undo();

                          final last = txnNotifier.lastDeleted;
                          if (last != null) {
                            searchNotifier.addBack(last);
                          } */
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            if (searchState.isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
















/* 
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

                // DELETE
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
 */