import 'package:etrace/Api/UpdateService.dart';
import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UpdateExpensePage extends ConsumerStatefulWidget {
  const UpdateExpensePage({
    required this.emerald,
    super.key,
    required this.transaction,
  });
  final Color emerald;
  final Transaction transaction;

  @override
  ConsumerState<UpdateExpensePage> createState() => _UpdateExpensePageState();
}

class _UpdateExpensePageState extends ConsumerState<UpdateExpensePage> {
  final _formKey = GlobalKey<FormState>();

  final dateController = TextEditingController();
  final oldDateController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController();

  final Color blackShade = const Color(0xFF1C1C1C);

  @override
  void dispose() {
    dateController.dispose();
    oldDateController.dispose();
    noteController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    oldDateController.text = widget.transaction.date.isNotEmpty
        ? widget.transaction.date
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.emerald,
        elevation: 0,
        title: const Text(
          "Update Expense",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: widget.emerald,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: oldDateController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                readOnly: true,
                decoration: CustomeInputDecorator(
                  widget.transaction.date,
                  Icons.calendar_today,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: dateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator(
                  "New Expense Date",
                  Icons.calendar_today,
                ),
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateController.text = DateFormat(
                      'yyyy-MM-dd',
                    ).format(picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: categoryController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator("Category", Icons.label),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator("Note", Icons.note),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Update Expense",
                  emerald: widget.emerald,
                  blackShade: blackShade,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final data = await UpdateService().updateExpense(
                      widget.transaction.id,
                      dateController.text,
                      categoryController.text,
                      noteController.text,
                    );
                    if (data != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Expense updated successfully!",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: blackShade,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Failed to update expense. Try again.",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
