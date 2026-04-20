import 'dart:convert';

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  /// Factory constructor to parse JSON into Category
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] ?? '',
      // deliberately ignore json['username']
    );
  }

  /// Convert Category back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      // omit username
    };
  }

  /// Parse a list of categories from JSON (string or list)
  static List<Category> listFromJson(dynamic data) {
    if (data is String) {
      final decoded = json.decode(data) as List;
      return decoded.map((e) => Category.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => Category.fromJson(e)).toList();
    }
    return [];
  }
}
