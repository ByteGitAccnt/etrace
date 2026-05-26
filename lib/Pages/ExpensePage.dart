import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Pages/UpdateExpensePage.dart';
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

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    // =====================================================
    // PAGINATION
    // =====================================================
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Trigger before absolute bottom for smoother UX
    if (position.pixels >= position.maxScrollExtent - 200) {
      final notifier = ref.read(transactionProvider.notifier);
      final state = ref.read(transactionProvider);

      if (!state.isLoadingExpenses && state.expenseHasMore) {
        notifier.fetchMoreExpenses();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);

    // =====================================================
    // NEW STATE ACCESS
    // No filtering needed because provider already separates
    // expenses from reserves
    // =====================================================
    final expenseList = state.expenseItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: emerald,
        title: const Text("Transactions"),
      ),
      backgroundColor: emerald,
      body: SafeArea(
        child: Column(
          children: [
            // =================================================
            // MAIN LIST
            // =================================================
            Expanded(
              child: TransactionList(
                transactions: expenseList,
                enableDelete: true,
                controller: _scrollController,

                onDelete: (tx, index) {
                  final notifier = ref.read(transactionProvider.notifier);

                  notifier.deleteById(tx.id, true);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Item will be removed"),
                      duration: const Duration(seconds: 3),
                      action: SnackBarAction(
                        label: "UNDO",
                        onPressed: notifier.undo,
                      ),
                    ),
                  );
                },
                onEdit: (tx) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UpdateExpensePage(transaction: tx, emerald: emerald),
                    ),
                  );
                },
              ),
            ),

            // =================================================
            // LOADING STATES
            // =================================================

            // First load spinner
            if (state.isLoadingExpenses && expenseList.isEmpty)
              const Expanded(child: Center(child: CircularProgressIndicator())),

            // Pagination spinner
            if (state.isLoadingExpenses && expenseList.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),

            // =================================================
            // ERROR
            // =================================================
            if (state.error != null && expenseList.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }
}
