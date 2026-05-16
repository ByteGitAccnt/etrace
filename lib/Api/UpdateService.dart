import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:etrace/Api/ApiClient.dart';
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
}
