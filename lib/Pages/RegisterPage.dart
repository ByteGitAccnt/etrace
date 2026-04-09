import 'package:etrace/Api/AuthService.dart';
import 'package:etrace/Model/User.dart';
import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';

class Registerpage extends StatefulWidget {
  Registerpage({required this.emerald, super.key});
  final Color emerald;

  @override
  State<Registerpage> createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  final Color blackShade = const Color(0xFF1C1C1C);

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPass = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    _confirmPass.dispose();
    _email.dispose();
    _name.dispose();
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
                  "Register",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Name", Icons.person),
                  controller: _name,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null; // valid input
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Email", Icons.email),
                  controller: _email,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null; // valid input
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator(
                    "Username",
                    Icons.account_circle,
                  ),
                  controller: _username,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
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
                      return 'This field cannot be empty';
                    }
                    return null; // valid input
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator(
                    "Confirm password",
                    Icons.lock,
                  ),
                  controller: _confirmPass,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'This field cannot be empty';
                    }
                    return null; // valid input
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 365,
                  child: ModernButton(
                    text: "Register",
                    emerald: widget.emerald,
                    blackShade: blackShade,
                    onPressed: () async {
                      HapticFeedback.lightImpact();

                      if (!_formKey.currentState!.validate()) return;

                      final user = await AuthService().register(
                        _name.text,
                        _email.text,
                        _username.text,
                        _password.text,
                        _confirmPass.text,
                      );

                      if (user != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Registration successful! Please login.",
                              style: TextStyle(color: Colors.white),
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );

                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Registration failed. Please try again.",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: blackShade,
                          ),
                        );
                      }
                    },
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
