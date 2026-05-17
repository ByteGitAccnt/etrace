// =============================================================
// BALANCE CARD
// PURPOSE:
// Separate static UI shell from dynamic provider rebuilds
//
// WHY:
// Before:
// Entire gradient + icon + shadow rebuilt
//
// Now:
// Only balance text rebuilds
// =============================================================
import 'package:etrace/Utils/BalanceCardContent.dart';
import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // Static gradient stays untouched
          gradient: const LinearGradient(
            colors: [Color(0xFF046A38), Color(0xFF2EBB57)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

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
            // =================================================
            // DYNAMIC CONTENT ONLY
            // =================================================
            const BalanceCardContent(),

            // =================================================
            // STATIC ICON
            // =================================================
            Positioned(
              right: 0,
              top: 0,
              child: IgnorePointer(
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 130,
                  color: Colors.white30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
