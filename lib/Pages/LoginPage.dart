import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';

class LoginPage extends StatefulWidget {
  LoginPage({required this.emerald, super.key});
  final Color emerald;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      backgroundColor: widget.emerald, // optional background
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
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Email", Icons.email),
                  controller: _username,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'required';
                    }
                    return null; // valid input
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Password", Icons.lock),
                  controller: _password,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'required';
                    }
                    return null; // valid input
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 365,
                  child: ModernButton(
                    text: "Login",
                    emerald: widget.emerald,
                    blackShade: blackShade,
                    onPressed: () async {
                      HapticFeedback.lightImpact();

                      if (!_formKey.currentState!.validate()) return;
                      log(
                        "Logging in with: ${_username.text} / ${_password.text}",
                      );
                      /* final success = await AuthService().login(
                        _username.text,
                        _password.text,
                      ); */
                      bool success = true;
                      if (success) {
                        print("object");
                        Navigator.pushReplacementNamed(context, '/home');
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
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    "Don’t have an account? Sign up",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 17),
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
