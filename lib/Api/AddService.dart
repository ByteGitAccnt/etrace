import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Model/Expense.dart';
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
        final data = response.data;
        return User.fromJson(data);
      } else {
        log("Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return null;
    }
  }

  Future<Object?> addExpense(
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
        final data = response.data;
        return Expense.fromJson(data);
      } else {
        log("Failed: ${response.statusCode} - ${response.data}");
        return null;
      }
    } on DioException catch (e) {
      log("Network Error: $e");
      return Future(() => null);
    }
  }

  // addResreved
  // deposite reserve
}
