import 'package:etrace/Model/User.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<User?> AddExpense(
  String name,
  String email,
  String username,
  String password,
  String confirmPass,
) async {
  final baseUrl = dotenv.env['BASE_URL'];
  //  basic frontend validation
  if (password != confirmPass) {
    print("Passwords do not match"); // need to remove after testing
    return null;
  }
  final url = Uri.parse("$baseUrl/api/auth/register");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "password": password,
        "confirmPassword": confirmPass,
        "name": name,
        "email": email,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);

      //  convert JSON → User object
      final user = User.fromJson(data);

      return user;
    } else {
      print(
        "Failed: ${response.statusCode} - ${response.body}",
      ); // need to remove after testing
      return null;
    }
  } catch (e) {
    print("Network error: $e");
    return null;
  }
}
