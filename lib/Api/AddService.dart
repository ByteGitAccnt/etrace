import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Model/Expense.dart';
import 'package:etrace/Model/Reserved.dart';
import 'package:etrace/Model/User.dart';

class AddService {
  final Dio dio = ApiClient().dio;

  Future<User?> addIncome(double amount) async {
    if (amount <= 0) {
      log("Invalid income amount");
      return null;
    }
    try {
      final response = await dio.post(
        "/api/auth/income",
        data: {"amount": amount},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final json = response.data;
        return User.fromJson(json);
      } else {
        log("Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return null;
    }
  }

  Future<Expense?> addExpense(
    double amount,
    DateTime expenseDate,
    String category,
    String note,
    bool isReserved,
    String? label,
  ) async {
    if (amount <= 0) {
      log("Invalid expense amount");
      return Future(() => null);
    }
    try {
      final response = await dio.post(
        "/api/expense",
        data: {
          "amount": amount,
          "expenseDate": expenseDate.toIso8601String(),
          "category": category,
          "note": note,
          "isReserved": isReserved,
          "label": isReserved ? label : null,
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final json = response.data;
        return Expense.fromJson(json);
      } else {
        log("Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return Future(() => null);
    }
  }

  Future<Reserved?> addReserve(double amount, String label, String note) async {
    if (amount <= 0) {
      log("Invalid reserve amount");
      return Future(() => null);
    }
    try {
      final response = await dio.post(
        "/api/reserve",
        data: {"amount": amount, "label": label, "note": note},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final json = response.data;
        return Reserved.fromJson(json);
      } else {
        log("Failed: ${response.statusCode} - ${response.data}");
        return Future(() => null);
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return Future(() => null);
    }
  }

  Future<Reserved?> addDepositeReserve(double amount, String label) async {
    if (amount <= 0) {
      log("invalid reserve amount!");
      return Future(() => null);
    }
    try {
      final response = await dio.post(
        "/api/reserve/deposite",
        data: {"amount": amount, "label": label},
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final json = response.data;
        return Reserved.fromJson(json);
      } else {
        log("Failed: ${response.statusCode} - ${response.data}");
        return Future(() => null);
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return Future(() => null);
    }
  }
}
