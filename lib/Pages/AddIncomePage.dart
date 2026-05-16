import 'dart:developer';

import 'package:etrace/Api/AddService.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({required this.emerald, super.key});
  final Color emerald;

  @override
  State<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final Color blackShade = const Color(0xFF1C1C1C);

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,

      appBar: AppBar(
        backgroundColor: widget.emerald,
        elevation: 0,
        title: const Text("Add Income", style: TextStyle(color: Colors.white)),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter amount";
                  }
                  if (double.tryParse(value) == null) {
                    return "Invalid amount";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              /// Submit
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Add Income",
                  emerald: widget.emerald,
                  blackShade: blackShade,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    // data needed to be added
                    final data = await AddService().addIncome(
                      double.parse(amountController.text),
                    );
                    if (data == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Failed to add income",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Income Added Successfully!",
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: blackShade,
                      ),
                    );

                    Navigator.pop(context);
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
