import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Pages/UpdateReservePage.dart';
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

    // =======================================================
    // KEEPING YOUR ORIGINAL LOADING STYLE
    // =======================================================
    Future.microtask(() {
      ref.read(transactionProvider.notifier).loadReserves();
    });
  }

  // =======================================================
  // REFRESH
  // =======================================================
  Future<void> _refreshReserves() async {
    await ref
        .read(transactionProvider.notifier)
        .loadReserves(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    // =======================================================
    // SELECTIVE WATCH
    // =======================================================
    final reserveList = ref.watch(
      transactionProvider.select((state) => state.reserveItems),
    );

    final isLoadingReserves = ref.watch(
      transactionProvider.select((state) => state.isLoadingReserves),
    );

    final error = ref.watch(transactionProvider.select((state) => state.error));

    return Scaffold(
      backgroundColor: emerald,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================
            // HEADER
            // =================================================
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

            // =================================================
            // BODY
            // =================================================
            Expanded(
              child:
                  // =============================================
                  // FIRST LOAD
                  // =============================================
                  (isLoadingReserves && reserveList.isEmpty)
                  ? const Center(child: CircularProgressIndicator())
                  // =========================================
                  // ERROR
                  // =========================================
                  : (error != null && reserveList.isEmpty)
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          error,
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  // =====================================
                  // EMPTY
                  // IMPORTANT:
                  // Use ListView so RefreshIndicator works
                  // =====================================
                  : reserveList.isEmpty
                  ? RefreshIndicator(
                      onRefresh: _refreshReserves,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 180),
                          Center(
                            child: Text(
                              "No reserve transactions",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    )
                  // =================================
                  // DATA
                  // =================================
                  : Stack(
                      children: [
                        // =============================
                        // REFRESH PRESERVED
                        // =============================
                        RefreshIndicator(
                          onRefresh: _refreshReserves,

                          child: TransactionList(
                            transactions: reserveList,
                            isExpense: false,

                            onDelete: (tx, index) {
                              final notifier = ref.read(
                                transactionProvider.notifier,
                              );

                              notifier.deleteById(tx.id, false);

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
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
                                  builder: (_) => UpdateReservePage(
                                    transaction: tx,
                                    emerald: emerald,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // =============================
                        // BACKGROUND REFRESH LOADER
                        // =============================
                        if (isLoadingReserves)
                          const Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Center(child: CircularProgressIndicator()),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
