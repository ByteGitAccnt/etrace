// lib/input_decorations.dart
import 'package:flutter/material.dart';

InputDecoration CustomeInputDecorator(
  String hint,
  IconData icon, {
  Color iconColor = Colors.green,
}) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: iconColor),
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: const Color(0xFF1C1C1C),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: iconColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: iconColor, width: 2),
    ),
  );
}
