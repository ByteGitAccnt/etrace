import 'package:etrace/Utils/TransactionList.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
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
    ];
    return Column(
      children: [
        const SizedBox(height: 24),
        _buildBalanceCard(),
        const SizedBox(height: 20),
        TransactionList(title: "Recent Expenses", transactions: transactions),
        const Spacer(),
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
          // Content
          Column(
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
          ),
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
