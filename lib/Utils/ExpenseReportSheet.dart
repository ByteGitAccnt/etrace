import 'package:etrace/Notifiers/report/ReportNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseReportSheet extends ConsumerStatefulWidget {
  const ExpenseReportSheet({super.key});

  @override
  ConsumerState<ExpenseReportSheet> createState() => _ExpenseReportSheetState();
}

class _ExpenseReportSheetState extends ConsumerState<ExpenseReportSheet> {
  static const Color emeraldDark = Color(0xFF046A38);

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    super.dispose();
  }

  Future<void> pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 25),

            const Icon(Icons.picture_as_pdf, size: 60, color: emeraldDark),

            const SizedBox(height: 15),

            const Text(
              "Expense Report",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),

            const SizedBox(height: 8),

            Text(
              "Select a date range to generate your PDF report.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade700),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: fromDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "From Date",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () => pickDate(fromDateController),
            ),

            const SizedBox(height: 18),

            TextField(
              controller: toDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "To Date",
                prefixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              onTap: () => pickDate(toDateController),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: emeraldDark,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  await ref
                      .read(reportNotifierProvider.notifier)
                      .generateExpenseReport(
                        from: DateTime.parse(fromDateController.text),
                        to: DateTime.parse(toDateController.text),
                      );
                },
                icon: const Icon(Icons.download),
                label: const Text("Generate PDF"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
