import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Utils/BalanceNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:etrace/Utils/TransactionNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(balanceProvider.notifier).fetchBalance();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get data from Riverpod
    final allTransactions = ref.watch(transactionProvider);

    // Take only recent 7
    final recentTransactions = allTransactions.take(7).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        _buildBalanceCard(),
        const SizedBox(height: 20),
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

        Expanded(
          child: TransactionList(
            transactions: recentTransactions.isEmpty
                ? [
                    Transaction(
                      id: 0,
                      title: "No transactions yet",
                      amount: 0,
                      date: "",
                      icon: Icons.info_outline,
                    ),
                  ]
                : recentTransactions,

            onDelete: (tx, index) {}, // not needed here
            enableDelete: false, // ✅ disable delete
          ),
        ),
      ],
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
