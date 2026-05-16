import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
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

    // 🔹 Initial load
    Future.microtask(() {
      ref.read(transactionProvider.notifier).load();
    });

    // 🔹 Infinite scroll
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final notifier = ref.read(transactionProvider.notifier);
        final state = ref.read(transactionProvider);

        if (!state.isLoading && state.hasMore) {
          notifier.fetchMore();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);
    final expenseList = state.items.where((t) => t.isExpense).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: emerald,
        title: const Text("Transactions"),
      ),
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: TransactionList(
                transactions: expenseList,
                enableDelete: true,
                controller: _scrollController,

                onDelete: (tx, index) {
                  final notifier = ref.read(transactionProvider.notifier);

                  notifier.deleteById(tx.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Item deleted"),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: () {
                          notifier.undo();
                        },
                      ),
                    ),
                  );
                },
              ),
            ),

            if (state.isLoading)
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
