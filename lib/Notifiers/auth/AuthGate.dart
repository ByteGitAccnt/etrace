import 'package:etrace/Notifiers/auth/AuthNotifier.dart';
import 'package:etrace/Notifiers/auth/AuthStatus.dart';
import 'package:etrace/Pages/HomePage.dart';
import 'package:etrace/Pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const Color emerald = Color(0xFF046A38);

    final authState = ref.watch(authProvider);

    switch (authState) {
      case AuthStatus.loading:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));

      case AuthStatus.authenticated:
        return HomePage(emerald: emerald);

      case AuthStatus.unauthenticated:
        return LoginPage(emerald: emerald);
    }
  }
}








/* 
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  /*  @override
  void initState() {
    super.initState();

    //  Connect ApiClient → authProvider
    ApiClient().onUnauthorized = () {
      ref.read(authProvider.notifier).state = false;
    };
  }
 */
  @override
  void initState() {
    super.initState();
    // 🔥 connect ApiClient → Riverpod
    ApiClient().onUnauthorized = () {
      ref.read(authProvider.notifier).state = false;
    };
    Future.microtask(() {
      final token = TokenManager().accessToken;

      if (token != null) {
        ref.read(authProvider.notifier).state = true;
      }
    });
    /* final token = TokenManager().accessToken;

    if (token != null) {
      ref.read(authProvider.notifier).state = true;
    } */
  }

  @override
  Widget build(BuildContext context) {
    const Color emerald = Color(0xFF046A38);

    final isLoggedIn = ref.watch(authProvider);

    if (!isLoggedIn) {
      return LoginPage(emerald: emerald);
    }

    return HomePage(emerald: emerald);
  }
}

/* // needed later 
final authProvider = StateProvider<bool>((ref) {
  final token = TokenManager().accessToken;

  //  If token exists → user is logged in
  return token != null;
});
 */
final authProvider = StateProvider<bool>((ref) => false);
 */