import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservePage extends ConsumerStatefulWidget {
  const ReservePage({super.key});

  @override
  ConsumerState<ReservePage> createState() => _ReservePageState();
}

class _ReservePageState extends ConsumerState<ReservePage> {
  final Color emerald = const Color(0xFF046A38);

  @override
  void initState() {
    super.initState();

    // ✅ NEW: Explicitly load reserve data from backend
    Future.microtask(() {
      ref
          .read(transactionProvider.notifier)
          .load(
            isExpense: false, // 🔥 IMPORTANT: tells backend to fetch reserve
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);

    // STILL KEEP FILTER (safety)
    // even though backend returns reserve, this avoids accidental mix
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
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // ✅ NEW: show loading state
                  : reserveList.isEmpty
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

                        // ✅ SAME: delete by ID
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
