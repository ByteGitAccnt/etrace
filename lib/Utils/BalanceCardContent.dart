// =============================================================
// DYNAMIC BALANCE CONTENT
// =============================================================
import 'package:etrace/Notifiers/balance/BalanceNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer';

class BalanceCardContent extends ConsumerWidget {
  const BalanceCardContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceState = ref.watch(balanceProvider);

    return balanceState.when(
      data: (balance) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Available Balance",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const SizedBox(height: 8),

          Text(
            "₹ ${(balance.accountBalance - balance.reservedBalance).toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 13),

          const Text(
            "Total Balance",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),

          const SizedBox(height: 4),

          Text(
            "₹ ${balance.accountBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          if (balance.reservedBalance > 0) ...[
            const Text(
              "Reserve Fund",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),

            const SizedBox(height: 4),

            Text(
              "₹ ${balance.reservedBalance.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
      loading: () =>
          const Center(child: CircularProgressIndicator(color: Colors.white)),

      error: (err, stackTrace) {
        log('Failed to load balance', error: err, stackTrace: stackTrace);

        return const Center(
          child: Text(
            "Unable to load balance",
            style: TextStyle(color: Colors.white70),
          ),
        );
      },
    );
  }
}
