import 'package:etrace/Model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:etrace/Utils/TransactionItem.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isExpense;
  final bool enableDelete;
  final Function(Transaction tx, int index) onDelete;

  // ScrollController (optional)
  final ScrollController? controller;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
    this.enableDelete = true,
    this.isExpense = true,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.builder(
          //CHANGE: attach controller
          controller: controller,

          itemCount: transactions.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final tx = transactions[index];

            return Slidable(
              key: ValueKey(tx.id),

              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      onDelete(tx, index);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${tx.title} deleted")),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              enabled: enableDelete,
              child: TransactionItem(transaction: tx, isExpense: isExpense),
            );
          },
        ),
      ),
    );
  }
}
