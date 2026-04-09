import 'dart:convert';

class User {
  final int userId;
  final String username;
  final String email;
  final double amount;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.amount,
  });

  /// Convert JSON → User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Handle both int and string IDs safely
      userId: json["userid"] is String
          ? int.parse(json["userid"])
          : json["userid"] as int,
      username: json["username"] ?? "",
      email: json["email"] ?? "",
      amount: (json["amount"] as num).toDouble(),
    );
  }

  /// Convert User → JSON (for Dio POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      "userid": userId,
      "username": username,
      "email": email,
      "amount": amount,
    };
  }

  /// Parse a list of users from Dio response
  static List<User> listFromJson(dynamic data) {
    if (data is String) {
      final decoded = json.decode(data) as List;
      return decoded.map((e) => User.fromJson(e)).toList();
    } else if (data is List) {
      return data.map((e) => User.fromJson(e)).toList();
    }
    return [];
  }

  /// Convert a list of users to JSON string
  static String listToJson(List<User> users) {
    return json.encode(users.map((u) => u.toJson()).toList());
  }
}
