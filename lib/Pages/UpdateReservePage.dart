import 'package:etrace/Api/UpdateService.dart';
import 'package:etrace/Model/Transaction.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateReservePage extends ConsumerStatefulWidget {
  const UpdateReservePage({
    required this.emerald,
    required this.transaction,
    super.key,
  });
  final Color emerald;
  final Transaction transaction;

  @override
  ConsumerState<UpdateReservePage> createState() => _UpdateReservePageState();
}

class _UpdateReservePageState extends ConsumerState<UpdateReservePage> {
  final _formKey = GlobalKey<FormState>();

  final oldlabelController = TextEditingController();
  final newlabelController = TextEditingController();
  final noteController = TextEditingController();

  final Color blackShade = const Color(0xFF1C1C1C);

  @override
  void dispose() {
    oldlabelController.dispose();
    newlabelController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    oldlabelController.text = widget.transaction.title.isNotEmpty
        ? widget.transaction.title
        : "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.emerald,
        elevation: 0,
        title: const Text(
          "Update Reserve",
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
                controller: oldlabelController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator(
                  widget.transaction.title,
                  Icons.label,
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter old label" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: newlabelController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: CustomeInputDecorator("New label", Icons.label),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter new label" : null,
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
                  text: "Update Reserved",
                  emerald: widget.emerald,
                  blackShade: blackShade,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final data = await UpdateService().updateReserved(
                      oldlabelController.text,
                      newlabelController.text,
                      noteController.text,
                    );
                    if (data != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            "Reserved updated successfully!",
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
                            "Failed to update reserved. Try again.",
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
