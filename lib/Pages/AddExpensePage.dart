import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';

class AddExpensePage extends StatefulWidget {
  AddExpensePage({required this.emerald, super.key});
  final Color emerald;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final noteController = TextEditingController();
  final labelController = TextEditingController();
  final dateController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  String? selectedCategory;
  bool isReserved = false;

  final List<String> categories = ["Food", "Travel", "Fun", "Bills"];

  final Color blackShade = const Color(0xFF1C1C1C);

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    labelController.dispose();
    dateController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,

      appBar: AppBar(
        backgroundColor: widget.emerald,
        elevation: 0,
        title: const Text("Add Expense", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// Amount
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator(
                  "Amount",
                  Icons.currency_rupee,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter amount" : null,
              ),

              const SizedBox(height: 16),

              /// Date
              TextFormField(
                controller: dateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator(
                  "Expense Date",
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
                    dateController.text = picked.toIso8601String().split(
                      "T",
                    )[0];
                  }
                },
              ),

              const SizedBox(height: 16),

              /// Category
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
              const SizedBox(height: 16),

              /// Note
              TextFormField(
                controller: noteController,
                maxLines: 3,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator("Note", Icons.note),
              ),
              const SizedBox(height: 16),

              /// Reserved Radio
              Row(
                children: [
                  const Text(
                    "Reserved?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Radio<bool>(
                    value: true,
                    groupValue: isReserved,
                    activeColor: Colors.white,
                    onChanged: (val) {
                      setState(() => isReserved = val!);
                    },
                  ),
                  const Text(
                    "Yes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Radio<bool>(
                    value: false,
                    groupValue: isReserved,
                    activeColor: Colors.white,
                    onChanged: (val) {
                      setState(() => isReserved = val!);
                    },
                  ),
                  const Text(
                    "No",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// Label (conditional)
              if (isReserved)
                TextFormField(
                  controller: labelController,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Label", Icons.label),
                  validator: (value) {
                    if (isReserved && (value == null || value.isEmpty)) {
                      return "Label required";
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 25),

              /// Submit Button
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Submit Expense",
                  emerald: widget.emerald,
                  blackShade: blackShade,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        "amount": double.parse(amountController.text),
                        "expenseDate": dateController.text,
                        "category": selectedCategory,
                        "note": noteController.text,
                        "isReserved": isReserved,
                        "label": labelController.text,
                      };

                      print(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Expense Added Successfully!",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: blackShade,
                        ),
                      );
                      //no need to pop now , we stay
                      /* Navigator.pop(
                        context,
                      );  */
                      // submit logic need to be implemented
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
