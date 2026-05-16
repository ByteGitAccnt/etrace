import 'package:etrace/Model/Category.dart';
import 'package:etrace/Notifiers/category/CategoryNotifier.dart';
import 'package:etrace/Notifiers/transaction/TransactionNotifier.dart';
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
  Category? selectedCategory;

  @override
  void dispose() {
    fromDateController.dispose();
    toDateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(categoryProvider.notifier).load();
    });
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

    final hasFrom = fromDate.isNotEmpty;
    final hasTo = toDate.isNotEmpty;

    //  Only validation UI should do
    if (hasFrom != hasTo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select both From and To dates or leave both empty."),
        ),
      );
      return;
    }

    //  Single unified call
    await ref
        .read(transactionProvider.notifier)
        .loadExpenses(
          fromDate: hasFrom ? fromDate : null,
          toDate: hasTo ? toDate : null,
          category: selectedCategory?.id,
        );

    //  Navigate after state is updated
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
              Consumer(
                builder: (context, ref, _) {
                  final categoryState = ref.watch(categoryProvider);
                  final categories = categoryState.items;

                  return Autocomplete<Category>(
                    displayStringForOption: (c) => c.name,

                    optionsBuilder: (text) {
                      if (text.text.isEmpty) return categories;

                      return categories.where(
                        (c) => c.name.toLowerCase().contains(
                          text.text.toLowerCase(),
                        ),
                      );
                    },

                    onSelected: (category) {
                      selectedCategory = category;
                      categoryController.text = category.name;
                    },

                    fieldViewBuilder:
                        (context, controller, focusNode, onFieldSubmitted) {
                          return TextFormField(
                            controller: controller,
                            focusNode: focusNode,
                            style: const TextStyle(color: Colors.white),
                            decoration: CustomeInputDecorator(
                              "Category",
                              Icons.category,
                            ),

                            //  DIFFERENCE FROM ADD PAGE
                            onChanged: (value) {
                              // user typed → invalidate selection
                              selectedCategory = null;
                            },
                          );
                        },
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
