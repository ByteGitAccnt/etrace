import 'package:flutter/material.dart';

class ModernButton extends StatelessWidget {
  final String text;
  final Color emerald;
  final Color blackShade;
  final VoidCallback onPressed;

  const ModernButton({
    required this.text,
    required this.emerald,
    required this.blackShade,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: blackShade,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: emerald, width: 2),
        ),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
