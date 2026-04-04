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
      userId: json["userid"],
      username: json["username"],
      email: json["email"],
      amount: (json["amount"] as num).toDouble(),
    );
  }

  /// Convert User → JSON (useful later)
  Map<String, dynamic> toJson() {
    return {
      "userid": userId,
      "username": username,
      "email": email,
      "amount": amount,
    };
  }
}
