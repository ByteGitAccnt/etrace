import 'package:etrace/Utils/BalanceNotifier.dart';
import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContent extends StatelessWidget {
  // ned to omake it state ful
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {
        "title": "Food",
        "amount": 250,
        "date": "Apr 3",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Travel",
        "amount": 120,
        "date": "Apr 2",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Shopping",
        "amount": 800,
        "date": "Apr 1",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Shopping",
        "amount": 800,
        "date": "Apr 1",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Shopping",
        "amount": 800,
        "date": "Apr 1",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Shopping",
        "amount": 800,
        "date": "Apr 1",
        "icon": Icons.receipt_long,
      },
      {
        "title": "Shopping",
        "amount": 800,
        "date": "Apr 1",
        "icon": Icons.receipt_long,
      },
    ];

    // Inside HomeContent build method:
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
          // This forces the list to take up the remaining space and be scrollable
          child: TransactionList(transactions: transactions),
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
          /* Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Total Balance",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "₹ 0.00",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Reserve Fund",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              SizedBox(height: 6),
              Text(
                "₹ 0.00",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ), */
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
