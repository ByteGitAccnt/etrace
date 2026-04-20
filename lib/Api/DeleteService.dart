import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';

class DeleteService {
  final Dio dio = ApiClient().dio;
  Future<void> deleteExpense(int id) async {
    try {
      final response = await dio.delete("/api/expense/$id");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception(
          "Delete Failed: ${response.statusCode} - ${response.data}",
        );
      }
    } catch (e) {
      log("Delete Error: $e");
      rethrow; // notifier handles rollback
    }
  }

  Future<void> deleteReserve(int id) async {
    try {
      final response = await dio.delete("/api/reserve$id");

      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        throw Exception(
          "Delete Failed: ${response.statusCode} - ${response.data}",
        );
      }
    } catch (e) {
      log("Delete Error: $e");
      rethrow; // notifier handles rollback
    }
  }
}
