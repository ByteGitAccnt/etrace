import 'package:etrace/Api/Login.dart';
import 'package:etrace/Model/User.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User?> addIncome(double amount) async {
  final baseUrl = dotenv.env['BASE_URL'];

  // Basic validation
  if (amount <= 0) {
    print("Invalid income amount");
    return null;
  }

  final url = Uri.parse("$baseUrl/api/auth/income");
  final token = storage.read(key: "accessToken") ?? "";
  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", //  important
      },
      body: jsonEncode({"amount": amount}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Convert JSON → User object
      return User.fromJson(data);
    } else {
      print("Failed: ${response.statusCode} - ${response.body}");
      return null;
    }
  } catch (e) {
    print("Network error: $e");
    return null;
  }
}
