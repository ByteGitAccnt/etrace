import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Model/Expense.dart';
import 'package:etrace/Model/Reserved.dart';

class UpdateService {
  final Dio dio = ApiClient().dio;

  Future<Reserved?> withdrawReserve(double amount, String label) async {
    if (amount <= 0) {
      return Future(() => null);
    }
    try {
      final response = await dio.post(
        "/api/reserve/withdraw",
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

  Future<Reserved?> updateReserved(
    String oldname,
    String newname,
    String note,
  ) async {
    if (oldname.isEmpty || newname.isEmpty) {
      return Future(() => null);
    }
    if (oldname == newname) {
      return Future(() => null);
    }
    try {
      final response = await dio.put(
        "/api/reserve",
        data: {"old_label": oldname, "new_label": newname, "note": note},
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

  Future<Expense?> updateExpense(
    int id,
    String? expDate,
    String? category,
    String? note,
  ) async {
    if (id <= 0) {
      return Future(() => null);
    }
    try {
      final response = await dio.patch(
        "/api/expense",
        data: {
          "exp_id": id,
          "exp_date": expDate,
          "note": note,
          "category_name": category,
        },
      );
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final json = response.data;
        return Expense.fromJson(json);
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
