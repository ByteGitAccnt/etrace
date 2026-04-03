import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';

class AddReservePage extends StatefulWidget {
  const AddReservePage({required this.emerald, super.key});
  final Color emerald;

  @override
  State<AddReservePage> createState() => _AddReservePageState();
}

class _AddReservePageState extends State<AddReservePage> {
  final _formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final labelController = TextEditingController();

  final Color blackShade = const Color(0xFF1C1C1C);

  @override
  void dispose() {
    amountController.dispose();
    labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,

      appBar: AppBar(
        backgroundColor: widget.emerald,
        elevation: 0,
        title: const Text(
          "Add Reserved Money",
          style: TextStyle(color: Colors.white),
        ),
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

              const SizedBox(height: 16),

              /// Label (required)
              TextFormField(
                controller: labelController,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator("Label", Icons.label),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter label";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              /// Submit
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Add Reserved",
                  emerald: widget.emerald,
                  blackShade: blackShade,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final data = {
                        "amount": double.parse(amountController.text),
                        "label": labelController.text,
                      };

                      print(data);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Reserved fund Added Successfully!",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: blackShade,
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
