import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Model/Expense.dart';
import 'package:etrace/Model/Reserved.dart';

class FetchService {
  final Dio dio = ApiClient().dio;

  /// Fetch all expenses with optional pagination
  /// Set limit to a high number or 0 to get all items
  Future<List<Expense>> fetchExpenses({int page = 0, int size = 10}) async {
    try {
      try {
        final response = await dio.get(
          "/api/expense",
          queryParameters: {'page': page, 'size': size},
        );

        if (response.statusCode! >= 200 && response.statusCode! < 300) {
          final dynamic jsonList = response.data is List
              ? response.data
              : response.data['data'] ?? response.data['expenses'] ?? [];

          return Expense.listFromJson(jsonList);
        } else {
          log(
            "Failed to fetch expenses: ${response.statusCode} - ${response.data}",
          );
          return [];
        }
      } on DioException catch (e) {
        log("Network Error fetching expenses: $e");
        return [];
      }
    } on DioException catch (e) {
      log("Network Error fetching expenses: $e");
      return [];
    }
  }

  /// Fetch all reserves with optional pagination
  /// Set limit to a high number or 0 to get all items
  Future<List<Reserved>> fetchReserves({
    int limit = 1000, // Fetch up to 1000 items instead of default 10
    int offset = 0,
  }) async {
    try {
      final response = await dio.get(
        "/api/reserve",
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final List<dynamic> jsonList = response.data is List
            ? response.data
            : response.data['data'] ?? response.data['reserves'] ?? [];

        return jsonList
            .map((item) => Reserved.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        log(
          "Failed to fetch reserves: ${response.statusCode} - ${response.data}",
        );
        return [];
      }
    } on DioException catch (e) {
      log("Network Error fetching reserves: $e");
      return [];
    }
  }

  /// Fetch expenses by category with pagination
  Future<List<Expense>> fetchExpensesByCategoryAndDateRage(
    DateTime fromDate,
    DateTime toDate,
    String category, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await dio.get(
        "/api/expense",
        data: {
          "startDate": fromDate.toIso8601String(),
          "endDate": toDate.toIso8601String(),
          "catid": category,
          "page": page,
          "size": size,
        },
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final dynamic jsonList = response.data is List
            ? response.data
            : response.data['data'] ?? response.data['expenses'] ?? [];

        return Expense.listFromJson(jsonList);
      } else {
        log("Failed to fetch expenses by category: ${response.statusCode}");
        return [];
      }
    } on DioException catch (e) {
      log("Network Error fetching expenses by category: $e");
      return [];
    }
  }

  /// Fetch expenses by date range with pagination
  Future<List<Expense>> fetchExpensesByDateRange(
    DateTime fromDate,
    DateTime toDate, {
    int page = 0,
    int size = 0,
  }) async {
    try {
      final response = await dio.get(
        "/api/expense",
        data: {
          "startDate": fromDate.toIso8601String(),
          "endDate": toDate.toIso8601String(),
          "page": page,
          "size": size,
        },
      );

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final dynamic jsonList = response.data is List
            ? response.data
            : response.data['data'] ?? response.data['expenses'] ?? [];

        return Expense.listFromJson(jsonList);
      } else {
        log("Failed to fetch expenses by date range: ${response.statusCode}");
        return [];
      }
    } on DioException catch (e) {
      log("Network Error fetching expenses by date range: $e");
      return [];
    }
  }
}
