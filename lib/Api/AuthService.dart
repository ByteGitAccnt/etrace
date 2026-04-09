import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Model/User.dart';

class AuthService {
  final Dio dio = ApiClient().dio;
  final TokenManager tokenManager = TokenManager();

  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        "/api/auth/login",
        data: {"username": username, "password": password},
      );

      final data = response.data;

      final accessToken = data["accessToken"];
      final refreshToken = data["refreshToken"];

      if (accessToken != null && refreshToken != null) {
        await tokenManager.saveTokens(accessToken, refreshToken);
        return true;
      }

      return false;
    } on DioException catch (e) {
      log("Login Error: ${e.response?.data}");
      return false;
    }
  }

  Future<User?> register(
    String name,
    String email,
    String username,
    String password,
    String confirmPass,
  ) async {
    try {
      final response = await dio.post(
        "/api/auth/register",
        data: {
          "username": username,
          "password": password,
          "confirmPassword": confirmPass,
          "name": name,
          "email": email,
        },
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final data = response.data;
        final user = User.fromJson(data);
        return user;
      } else {
        log("Registration Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return null;
    }
  }
}
