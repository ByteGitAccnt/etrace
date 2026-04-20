import 'package:etrace/Notifiers/TransactionNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';

class ExpenseSearchPage extends ConsumerStatefulWidget {
  const ExpenseSearchPage({required this.emerald, super.key});
  final Color emerald;

  @override
  ConsumerState<ExpenseSearchPage> createState() => _ExpenseSearchPageState();
}

class _ExpenseSearchPageState extends ConsumerState<ExpenseSearchPage> {
  final _formKey = GlobalKey<FormState>();

  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final categoryController = TextEditingController();

  final List<String> categories = ["Food", "Travel", "Fun", "Bills"];

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    FocusScope.of(context).unfocus();

    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _searchExpenses(BuildContext context) async {
    final fromDate = fromDateController.text.trim();
    final toDate = toDateController.text.trim();
    final category = categoryController.text.trim();

    final hasFrom = fromDate.isNotEmpty;
    final hasTo = toDate.isNotEmpty;

    // 🔴 Only validation UI should do
    if (hasFrom != hasTo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select both From and To dates or leave both empty."),
        ),
      );
      return;
    }

    // ✅ Single unified call
    await ref
        .read(transactionProvider.notifier)
        .load(
          fromDate: hasFrom ? fromDate : null,
          toDate: hasTo ? toDate : null,
          category: category.isNotEmpty ? category : null,
        );

    // ✅ Navigate after state is updated
    Navigator.pushNamed(context, '/searchResults');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),

              // From Date
              TextFormField(
                controller: fromDateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator(
                  "From Date (optional)",
                  Icons.calendar_today,
                ),
                onTap: () => _pickDate(fromDateController),
              ),

              const SizedBox(height: 15),

              // To Date
              TextFormField(
                controller: toDateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator(
                  "To Date (optional)",
                  Icons.calendar_today,
                ),
                onTap: () => _pickDate(toDateController),
              ),

              const SizedBox(height: 20),

              // Category Autocomplete
              Autocomplete<String>(
                optionsBuilder: (text) {
                  if (text.text.isEmpty) return categories;
                  return categories.where(
                    (c) => c.toLowerCase().contains(text.text.toLowerCase()),
                  );
                },
                onSelected: (selection) {
                  categoryController.text = selection;
                },
                fieldViewBuilder: (context, controller, focusNode, _) {
                  focusNode.addListener(() {
                    if (!focusNode.hasFocus) {
                      categoryController.text = controller.text;
                    }
                  });

                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: CustomeInputDecorator(
                      "Category (optional)",
                      Icons.category,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Search Button
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Search",
                  emerald: widget.emerald,
                  blackShade: Colors.black,
                  onPressed: () async {
                    await _searchExpenses(context);
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

















/* import 'package:etrace/Notifiers/SearchNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';

class ExpenseSearchPage extends ConsumerStatefulWidget {
  const ExpenseSearchPage({required this.emerald, super.key});
  final Color emerald;

  @override
  ConsumerState<ExpenseSearchPage> createState() => _ExpenseSearchPageState();
}

class _ExpenseSearchPageState extends ConsumerState<ExpenseSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final categoryController = TextEditingController();
  final List<String> categories = ["Food", "Travel", "Fun", "Bills"];

  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    categoryController.dispose();

    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    FocusScope.of(context).unfocus();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _searchExpenses(BuildContext context) async {
    final fromDate = fromDateController.text;
    final toDate = toDateController.text;
    final category = categoryController.text;

    final hasFrom = fromDate.isNotEmpty;
    final hasTo = toDate.isNotEmpty;
    final hasCategory = category.isNotEmpty;

    if (!hasFrom && !hasTo && !hasCategory) {
      await ref.read(searchProvider.notifier).search();
    } else if (hasFrom && hasTo && !hasCategory) {
      await ref
          .read(searchProvider.notifier)
          .search(fromDate: fromDate, toDate: toDate);
    } else if (hasFrom && hasTo && hasCategory) {
      await ref
          .read(searchProvider.notifier)
          .search(fromDate: fromDate, toDate: toDate, category: category);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select both From and To dates, or leave both empty.",
          ),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 25),

              // From Date
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: fromDateController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: CustomeInputDecorator(
                        "From Date (optional)",
                        Icons.calendar_today,
                      ),
                      onTap: () => _pickDate(fromDateController),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // To Date
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: toDateController,
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: CustomeInputDecorator(
                        "To Date (optional)",
                        Icons.calendar_today,
                      ),
                      onTap: () => _pickDate(toDateController),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return categories;
                  }
                  return categories.where(
                    (category) => category.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },

                onSelected: (selection) {
                  categoryController.text = selection;
                },

                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
                      focusNode.addListener(() {
                        if (!focusNode.hasFocus) {
                          // When user clicks outside, dropdown closes automatically
                          // but you can also commit the text here if needed
                          categoryController.text = controller.text;
                        }
                      });
                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: CustomeInputDecorator(
                          "Category",
                          Icons.category,
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Enter category"
                            : null,
                      );
                    },
              ),
              const SizedBox(height: 10),
              // Search Button
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Search",
                  emerald: widget.emerald,
                  blackShade: Colors.black,
                  onPressed: () async {
                    await _searchExpenses(context);
                    Navigator.pushNamed(context, '/searchResults');
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
 */