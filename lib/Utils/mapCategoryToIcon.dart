import 'package:flutter/material.dart';

IconData mapCategoryToIcon(String category) {
  switch (category.toLowerCase()) {
    case "food":
    case "casual":
      return Icons.restaurant;

    case "travel":
      return Icons.flight;

    case "stationary":
      return Icons.book;

    case "fee hostel":
      return Icons.home;

    case "colage fee":
      return Icons.school;

    case "internet":
      return Icons.wifi;

    case "electricity bill":
      return Icons.lightbulb;

    case "dress - wearable":
      return Icons.checkroom;

    case "digital accesserios":
      return Icons.devices;

    case "dept":
      return Icons.handshake;

    case "amount withdrawal":
      return Icons.account_balance;

    default:
      return Icons.attach_money; // fallback
  }
}
