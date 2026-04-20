import 'dart:convert';

class Reserved {
  final int id;
  final String label;
  final double amount;
  final String note;

  Reserved({
    required this.id,
    required this.label,
    required this.amount,
    required this.note,
  });

  // Convert JSON → Reserved
  factory Reserved.fromJson(Map<String, dynamic> json) {
    return Reserved(
      id: json['id'] as int,
      label: json['label'] as String,
      amount: (json['amount'] as num).toDouble(),
      note: json['note'] as String,
    );
  }

  static List<Reserved> listFromJson(dynamic data) {
    if (data is String) {
      final decoded = json.decode(data) as List;
      return decoded.map((e) => Reserved.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => Reserved.fromJson(e)).toList();
    }
    return [];
  }

  // Convert Reserved → JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'amount': amount, 'note': note};
  }
}
