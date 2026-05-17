import 'package:etrace/Notifiers/balance/BalanceNotifier.dart';
import 'package:etrace/Notifiers/category/CategoryNotifier.dart';
import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  // =====================================================
  // INITIAL SESSION PRELOAD
  // =====================================================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(balanceProvider.notifier).fetchBalance();
      await Future.delayed(const Duration(milliseconds: 16));
      await ref.read(transactionProvider.notifier).loadExpenses();
      ref.read(categoryProvider.notifier).load();
      ref.read(transactionProvider.notifier).loadReserves();
    });
  }

  // =====================================================
  // GLOBAL HOME REFRESH
  // Pull-to-refresh = full sync
  // =====================================================
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
    final state = ref.watch(transactionProvider);

    // =====================================================
    // CACHED RECENT EXPENSES
    // =====================================================
    final recentTransactions = state.expenseItems.take(7).toList();

    return RefreshIndicator(
      onRefresh: _refreshHome,

      // ===================================================
      // IMPORTANT:
      // AlwaysScrollableScrollPhysics ensures pull works
      // even if content is small
      // ===================================================
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),

        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // =============================================
              // BALANCE CARD
              // =============================================
              _buildBalanceCard(),

              const SizedBox(height: 20),

              // =============================================
              // HEADER
              // =============================================
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

              // =============================================
              // FIRST LOAD
              // =============================================
              if (state.isLoadingExpenses && recentTransactions.isEmpty)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              // =============================================
              // ERROR
              // =============================================
              else if (state.error != null && recentTransactions.isEmpty)
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
              // =============================================
              // EMPTY
              // =============================================
              else if (recentTransactions.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "No transactions yet",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                )
              // =============================================
              // DATA
              // =============================================
              else
                Expanded(
                  child: TransactionList(
                    transactions: recentTransactions,
                    enableDelete: false,
                    onDelete: (_, __) {},
                  ),
                ),

              // =============================================
              // Background refresh loader
              // =============================================
              if (state.isLoadingExpenses && recentTransactions.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildBalanceCard() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),

        //  Gradient (major visual upgrade)
        gradient: const LinearGradient(
          colors: [Color(0xFF046A38), Color(0xFF2EBB57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        //Shadow (depth)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Consumer(
            builder: (context, ref, child) {
              final balanceState = ref.watch(balanceProvider);

              return balanceState.when(
                data: (balance) => SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Total Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "₹ ${balance.accountBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Reserve Fund",
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "₹ ${balance.reservedBalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (err, _) => Text("Error: $err"),
              );
            },
          ),

          // Content
          //  Decorative Icon (top right)
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.account_balance_wallet,
              size: 130,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    ),
  );
}
