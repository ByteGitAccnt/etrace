import 'dart:developer';

import 'package:etrace/Api/UpdateService.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';

class Withdrawreservemoney extends StatefulWidget {
  const Withdrawreservemoney({required this.emerald, super.key});
  final Color emerald;

  @override
  State<Withdrawreservemoney> createState() => _WithdrawreservemoneyState();
}

class _WithdrawreservemoneyState extends State<Withdrawreservemoney> {
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
          "Withdraw Reserve Money",
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
              SizedBox(height: 16),
              // Submit
              SizedBox(
                width: double.infinity,
                child: ModernButton(
                  text: "Withdraw Reserve Money",
                  emerald: widget.emerald,
                  blackShade: blackShade,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final data = await UpdateService().withdrawReserve(
                      double.parse(amountController.text),
                      labelController.text,
                    );

                    if (data == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Reserved fund withdraw failed!",
                            style: TextStyle(color: Color(0xFFFFFFFF)),
                          ),
                          duration: const Duration(seconds: 1),
                          backgroundColor: blackShade,
                        ),
                      );
                      return;
                    }
                    log(data.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          "Reserved fund withdrawn Successfully!",
                          style: TextStyle(color: Color(0xFFFFFFFF)),
                        ),
                        duration: const Duration(seconds: 1),
                        backgroundColor: blackShade,
                      ),
                    );
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
