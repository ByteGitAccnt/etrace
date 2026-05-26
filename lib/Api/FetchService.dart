import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Model/Category.dart' as CategoryModel;
import 'package:etrace/Model/Expense.dart';
import 'package:etrace/Model/Reserved.dart';
import 'package:flutter/foundation.dart';

class FetchService {
  final Dio dio = ApiClient().dio;

  /// Fetch all expenses with optional pagination
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
              : response.data['content'] ??
                    response.data['data'] ??
                    response.data['expenses'] ??
                    [];
          return await compute(parseExpenseList, jsonList);
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
  Future<List<Reserved>> fetchReserves() async {
    try {
      final response = await dio.get("/api/reserve");

      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final dynamic jsonList = response.data is List
            ? response.data
            : response.data['content'] ??
                  response.data['data'] ??
                  response.data['expenses'] ??
                  [];

        return await compute(parseReservedList, jsonList);
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
  Future<List<Expense>> fetchExpensesByCategoryAndDateRange(
    DateTime fromDate,
    DateTime toDate,
    int category, {
    int page = 0,
    int size = 10,
  }) async {
    try {
      final response = await dio.get(
        "/api/expense/category",
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
            : response.data['content'] ??
                  response.data['data'] ??
                  response.data['expenses'] ??
                  [];
        return await compute(parseExpenseList, jsonList);
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
    int size = 10,
  }) async {
    try {
      final response = await dio.get(
        "/api/expense/date",
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
            : response.data['content'] ??
                  response.data['data'] ??
                  response.data['expenses'] ??
                  [];
        return await compute(parseExpenseList, jsonList);
      } else {
        log("Failed to fetch expenses by date range: ${response.statusCode}");
        return [];
      }
    } on DioException catch (e) {
      log("Network Error fetching expenses by date range: $e");
      return [];
    }
  }

  Future<List<CategoryModel.Category>> fetchCategories() async {
    try {
      final response = await dio.get("/api/category");
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        final dynamic jsonList = response.data is List
            ? response.data
            : response.data['data'] ?? response.data['categories'] ?? [];

        return await compute(CategoryModel.parseCategoryList, jsonList);
      } else {
        log("Failed to fetch categories: ${response.statusCode}");
        return [];
      }
    } on DioException catch (e) {
      log("Network Error fetching categories: $e");
      return [];
    }
  }
}
