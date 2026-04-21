import 'package:etrace/Api/ApiClient.dart';
import 'package:etrace/Api/TokenManager.dart';
import 'package:etrace/Notifiers/AuthStatus.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<AuthStatus> {
  AuthNotifier() : super(AuthStatus.loading) {
    ApiClient().onUnauthorized = () {
      forceLogout();
    };
    _init();
  }

  Future<void> _init() async {
    final token = TokenManager().accessToken;

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
    await TokenManager().clearTokens();
    state = AuthStatus.unauthenticated;
  }

  void forceLogout() {
    // sed by ApiClient (401)
    state = AuthStatus.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthStatus>(
  (ref) => AuthNotifier(),
);
