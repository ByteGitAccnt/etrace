import 'package:etrace/Api/AuthService.dart';
import 'package:etrace/Notifiers/auth/AuthNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({required this.emerald, super.key});
  final Color emerald;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final Color blackShade = const Color(0xFF1C1C1C);
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.emerald,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                /// Email
                TextFormField(
                  controller: _username,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Email", Icons.email),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'required' : null,
                ),

                const SizedBox(height: 16),

                /// Password
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Password", Icons.lock),
                  validator: (value) =>
                      value == null || value.trim().isEmpty ? 'required' : null,
                ),

                const SizedBox(height: 24),

                /// Login Button
                SizedBox(
                  width: 365,
                  child: ModernButton(
                    text: "Login",
                    emerald: widget.emerald,
                    blackShade: blackShade,
                    onPressed: () async {
                      HapticFeedback.lightImpact();

                      if (!_formKey.currentState!.validate()) return;

                      final success = await AuthService().login(
                        _username.text,
                        _password.text,
                      );

                      if (!mounted) return;

                      if (success) {
                        //  Update global auth state
                        ref.read(authProvider.notifier).loginSuccess();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Login failed. Please try again.",
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: blackShade,
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// Register
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "Don’t have an account? Sign up",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
