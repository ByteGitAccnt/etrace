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
