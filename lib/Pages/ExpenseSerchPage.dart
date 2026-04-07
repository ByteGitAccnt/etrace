import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';

class ExpenseSearchPage extends StatefulWidget {
  const ExpenseSearchPage({required this.emerald, super.key});
  final Color emerald;

  @override
  State<ExpenseSearchPage> createState() => _ExpenseSearchPageState();
}

class _ExpenseSearchPageState extends State<ExpenseSearchPage> {
  final _formKey = GlobalKey<FormState>();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final categoryController = TextEditingController();
  final List<String> categories = ["Food", "Travel", "Fun", "Bills"];

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

  void _searchExpenses() {
    final fromDate = fromDateController.text;
    final toDate = toDateController.text;
    final category = categoryController.text;

    if (fromDate.isEmpty && toDate.isEmpty) {
      // Case 1: No dates → fetch all expenses (paged)
      debugPrint("Fetching all expenses with pagination...");
    } else if (category.isNotEmpty &&
        fromDate.isNotEmpty &&
        toDate.isNotEmpty) {
      // Case 4: Category + Date Range → filter by both
      debugPrint("Filtering $category expenses from $fromDate to $toDate");
    } else if (fromDate.isNotEmpty && toDate.isNotEmpty) {
      // Case 2: Both dates → filter by range
      debugPrint("Filtering expenses from $fromDate to $toDate");
    } else {
      // Case 3: Only one date entered → show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please select both From and To dates, or leave both empty.",
          ),
        ),
      );
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
                  onPressed: () => {
                    _searchExpenses(),
                    Navigator.pushNamed(context, '/searchResults'),
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
