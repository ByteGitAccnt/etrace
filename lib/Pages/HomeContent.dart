import 'package:etrace/Notifiers/balance/BalanceNotifier.dart';
import 'package:etrace/Notifiers/category/CategoryNotifier.dart';
import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Utils/BalanceCard.dart';
import 'package:etrace/Utils/RecentTransactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  // =========================================================
  // SINGLE SESSION PRELOAD
  // WHY:
  // Before:
  // Multiple provider updates triggered multiple rebuild waves
  //
  // Now:
  // Batch async startup to reduce UI thread rebuild storms
  // =========================================================
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadHome();
    });
  }

  // =========================================================
  // PRELOAD HOME DATA
  // WHY:
  // Parallel loading reduces sequential rebuild bursts
  // =========================================================
  Future<void> _preloadHome() async {
    await ref.read(balanceProvider.notifier).fetchBalance();
    await Future.delayed(const Duration(milliseconds: 16));
    await ref.read(transactionProvider.notifier).loadExpenses();
    ref.read(categoryProvider.notifier).load();
    ref.read(transactionProvider.notifier).loadReserves();
  }

  // =========================================================
  // GLOBAL REFRESH
  // WHY:
  // Force refresh still allowed, but grouped efficiently
  // =========================================================
  Future<void> _refreshHome() async {
    await Future.wait([
      ref.read(balanceProvider.notifier).fetchBalance(),
      ref.read(categoryProvider.notifier).load(forceRefresh: true),
      ref.read(transactionProvider.notifier).loadExpenses(forceRefresh: true),
      ref.read(transactionProvider.notifier).loadReserves(forceRefresh: true),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // =======================================================
    // SELECTIVE WATCH
    // WHY:
    // Before:
    // ref.watch(transactionProvider)
    // Entire widget rebuilt for unrelated state changes
    //
    // Now:
    // Only rebuild when expense list/loading/error changes
    // =======================================================
    final recentTransactions = ref.watch(
      transactionProvider.select(
        (state) => state.expenseItems.take(7).toList(),
      ),
    );

    final isLoadingExpenses = ref.watch(
      transactionProvider.select((state) => state.isLoadingExpenses),
    );

    final error = ref.watch(transactionProvider.select((state) => state.error));

    // =======================================================
    // LISTVIEW INSTEAD OF SINGLECHILDSCROLLVIEW + COLUMN
    // WHY:
    // Before:
    // Heavy full-screen layout calculations
    //
    // Now:
    // Lazy rendering + optimized scroll layout
    // =======================================================
    return RefreshIndicator(
      onRefresh: _refreshHome,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        children: [
          // =================================================
          // BALANCE CARD
          // Static shell + isolated Consumer
          // =================================================
          const BalanceCard(),

          const SizedBox(height: 20),

          // =================================================
          // HEADER
          // =================================================
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Recent Expenses",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // =================================================
          // FIRST LOAD
          // WHY:
          // Full page loader only when no cached data exists
          // =================================================
          if (isLoadingExpenses && recentTransactions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(child: CircularProgressIndicator()),
            )
          // =================================================
          // ERROR
          // =================================================
          else if (error != null && recentTransactions.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          // =================================================
          // EMPTY
          // =================================================
          else if (recentTransactions.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Center(
                child: Text(
                  "No transactions yet",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            )
          // =================================================
          // DATA
          // WHY:
          // Dashboard version:
          // No nested scroll conflict
          // No Slidable
          // Lightweight rendering
          // =================================================
          else
            RecentTransactionList(transactions: recentTransactions),

          // =================================================
          // BACKGROUND REFRESH
          // Keep cached data visible while syncing
          // =================================================
          if (isLoadingExpenses && recentTransactions.isNotEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
