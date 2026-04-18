import 'package:etrace/Model/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:etrace/Utils/TransactionItem.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isExpense;
  final bool enableDelete;
  final Function(Transaction tx, int index) onDelete;
  //final Function(double id) onDelete;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onDelete,
    this.enableDelete = true,
    this.isExpense = true,
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
          itemCount: transactions.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final tx = transactions[index];

            return Slidable(
              key: ValueKey(
                tx.id,
              ), // Placeholder, replace with actual ID if available

              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) {
                      onDelete(tx, index);
                      //onDelete(tx["id"]);
                      // Placeholder, replace with actual ID if available

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
