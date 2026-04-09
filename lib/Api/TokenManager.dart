import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  String? _accessToken;
  String? _refreshToken;

  final _storage = const FlutterSecureStorage();

  Future<void> loadTokens() async {
    _accessToken = await _storage.read(key: "accessToken");
    _refreshToken = await _storage.read(key: "refreshToken");
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> saveTokens(String access, String refresh) async {
    _accessToken = access;
    _refreshToken = refresh;
    await _storage.write(key: "accessToken", value: access);
    await _storage.write(key: "refreshToken", value: refresh);
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.deleteAll();
  }
}
