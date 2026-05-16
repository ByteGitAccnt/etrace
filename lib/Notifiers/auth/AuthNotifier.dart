import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Api/AuthService.dart';
import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Notifiers/auth/AuthStatus.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<AuthStatus> {
  final AuthService _authService = AuthService();
  final TokenManager _tokenManager = TokenManager();

  bool _isLoggingOut = false;
  AuthNotifier() : super(AuthStatus.loading) {
    ApiClient().onUnauthorized = () {
      forceLogout();
    };
    _init();
  }

  Future<void> _init() async {
    final token = _tokenManager.accessToken;

    if (token != null) {
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
    }
  }

  Future<void> loginSuccess() async {
    state = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
      await _authService.logout();
      _tokenManager
          .clearTokens(); // clear tokens immediately to prevent further API calls with old token
      state = AuthStatus.unauthenticated;
    } finally {
      _isLoggingOut = false;
    }
  }

  void forceLogout() async {
    if (_isLoggingOut) return;

    _isLoggingOut = true;
    // sed by ApiClient (401)
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>(
  (ref) => AuthNotifier(),
);
