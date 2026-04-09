import 'dart:convert';

class Expense {
  final int id;
  final double amount;
  final DateTime expenseDate;
  final String note;
  final String categoryName;

  Expense({
    required this.id,
    required this.amount,
    required this.expenseDate,
    required this.note,
    required this.categoryName,
  });

  /// Create Expense from JSON (Dio response.data is usually Map<String, dynamic>)
  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] as int,
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expenseDate']),
      note: json['note'] ?? '',
      categoryName: json['categoryName'] ?? '',
    );
  }

  /// Convert Expense to JSON (for POST/PUT requests with Dio)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'expenseDate': expenseDate.toIso8601String(),
      'note': note,
      'categoryName': categoryName,
    };
  }

  /// Helpers for list handling
  static List<Expense> listFromJson(dynamic data) {
    if (data is String) {
      final decoded = json.decode(data) as List;
      return decoded.map((e) => Expense.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => Expense.fromJson(e)).toList();
    }
    return [];
  }

  static String listToJson(List<Expense> expenses) {
    return json.encode(expenses.map((e) => e.toJson()).toList());
  }
}
