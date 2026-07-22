/*import 'package:etrace/Utils/ExpenseReportSheet.dart';
import 'package:etrace/Utils/ReportCard.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  static const Color emeraldDark = Color(0xFF046A38);
  static const Color emeraldLight = Color(0xFF2EBB57);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.68,
          
          children: [
            ReportCard(
              icon: Icons.picture_as_pdf_rounded,
              title: "Expense Report",
              subtitle: "Generate and download PDF.",
              enabled: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const ExpenseReportSheet(),
                );
              },
            ),

            const ReportCard(
              icon: Icons.bar_chart_rounded,
              title: "Monthly Summary",
              subtitle: "Coming Soon",
              enabled: false,
            ),

            const ReportCard(
              icon: Icons.category_rounded,
              title: "Category Report",
              subtitle: "Coming Soon",
              enabled: false,
            ),

            const ReportCard(
              icon: Icons.account_balance_wallet,
              title: "Budget Report",
              subtitle: "Coming Soon",
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:etrace/Utils/ExpenseReportSheet.dart';
import 'package:etrace/Utils/ReportCard.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 24),

          ReportCard(
            icon: Icons.picture_as_pdf_rounded,
            title: "Expense Report",
            subtitle: "Generate a PDF report for a selected date range.",
            enabled: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => const ExpenseReportSheet(),
              );
            },
          ),

          const SizedBox(height: 16),

          const ReportCard(
            icon: Icons.bar_chart_rounded,
            title: "Monthly Summary",
            subtitle: "Coming Soon",
            enabled: false,
          ),

          const SizedBox(height: 16),

          const ReportCard(
            icon: Icons.category_rounded,
            title: "Category Report",
            subtitle: "Coming Soon",
            enabled: false,
          ),

          const SizedBox(height: 16),

          const ReportCard(
            icon: Icons.account_balance_wallet,
            title: "Budget Report",
            subtitle: "Coming Soon",
            enabled: false,
          ),
        ],
      ),
    );
  }
}
