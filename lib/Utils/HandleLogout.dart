import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Notifiers/BalanceNotifier.dart';
import 'package:etrace/Notifiers/CategoryNotifier.dart';
import 'package:etrace/Notifiers/TransactionNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> HandleLogout(BuildContext context, WidgetRef ref) async {
  final confirm = await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Logout"),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  await TokenManager().clearTokens();

  ref.invalidate(transactionProvider);
  ref.invalidate(categoryProvider);
  ref.invalidate(balanceProvider);

  Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
}
