import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();

Future<bool> login(String username, String password) async {
  final baseUrl = dotenv.env['BASE_URL'];
  final url = Uri.parse("$baseUrl/api/auth/login");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"username": username, "password": password}),
  );
  print("STATUS: ${response.statusCode}");
  print("BODY: ${response.body}");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    final accessToken = data["accessToken"];
    final refreshToken = data["refreshToken"];
    await storage.write(key: "test", value: "123");
    print(await storage.read(key: "test"));
    //  store securely (important)
    await storage.write(key: "accessToken", value: accessToken);
    await storage.write(key: "refreshToken", value: refreshToken);

    return true;
  }
  return false;
}
