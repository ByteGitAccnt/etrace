import 'package:dio/dio.dart';
import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Config/app_Config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;
  final TokenManager tokenManager = TokenManager();
  void Function()? onUnauthorized;
  final baseUrl = AppConfig.baseUrl;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {"Content-Type": "application/json"},
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          //Attach token automatically from memory
          final token = tokenManager.accessToken;
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },

        onResponse: (response, handler) {
          return handler.next(response);
        },

        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = tokenManager.refreshToken;
            if (refreshToken != null) {
              try {
                //Call refresh endpoint
                final refreshDio = Dio(); // to avoid interceptor loop
                final refreshResponse = await refreshDio.post(
                  "$baseUrl/api/auth/refresh",
                  options: Options(headers: {"Refresh-Token": refreshToken}),
                );

                final newAccess = refreshResponse.data["accessToken"];
                final newRefresh = refreshResponse.data["refreshToken"];

                if (newAccess != null && newRefresh != null) {
                  await tokenManager.saveTokens(newAccess, newRefresh);

                  //Retry original request with new token
                  final requestOptions = e.requestOptions;
                  requestOptions.headers["Authorization"] = "Bearer $newAccess";

                  final retryResponse = await dio.fetch(requestOptions);
                  return handler.resolve(retryResponse);
                } else {
                  await tokenManager.clearTokens();
                  // Optionally: trigger logout flow
                  onUnauthorized?.call();
                }
              } catch (_) {
                await tokenManager.clearTokens();
                // Optionally: trigger logout flow
                onUnauthorized?.call();
              }
            } else {
              await tokenManager.clearTokens();
              // Optionally: trigger logout flow
              onUnauthorized?.call();
            }
          }
          return handler.next(e);
        },
      ),
    );
  }
}
