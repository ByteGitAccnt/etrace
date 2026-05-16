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

    // =====================================================
    // INITIAL RESERVE LOAD
    // =====================================================
    Future.microtask(() {
      ref.read(transactionProvider.notifier).loadReserves();
    });
  }

  // =======================================================
  // PULL TO REFRESH
  // Force backend sync
  // =======================================================
  Future<void> _refreshReserves() async {
    await ref
        .read(transactionProvider.notifier)
        .loadReserves(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionProvider);

    final reserveList = state.reserveItems;

    return Scaffold(
      backgroundColor: emerald,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshReserves,

          // =================================================
          // AlwaysScrollable allows pull even with empty list
          // =================================================
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===========================================
                  // HEADER
                  // ===========================================
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

                  const SizedBox(height: 12),

                  // ===========================================
                  // FIRST LOAD
                  // ===========================================
                  if (state.isLoadingReserves && reserveList.isEmpty)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  // ===========================================
                  // ERROR
                  // ===========================================
                  else if (state.error != null && reserveList.isEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.error!,
                            style: const TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  // ===========================================
                  // EMPTY
                  // ===========================================
                  else if (reserveList.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          "No reserve transactions",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  // ===========================================
                  // DATA
                  // ===========================================
                  else
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(
                            child: TransactionList(
                              transactions: reserveList,
                              isExpense: false,

                              onDelete: (tx, index) {
                                final notifier = ref.read(
                                  transactionProvider.notifier,
                                );

                                notifier.deleteById(tx.id);

                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                        "Item will be removed",
                                      ),
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

                          // =====================================
                          // Background refresh spinner
                          // =====================================
                          if (state.isLoadingReserves)
                            const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
