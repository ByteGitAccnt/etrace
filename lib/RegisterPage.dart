import 'package:etrace/Utils/ModerButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:etrace/Utils/CustomeInputDecorator.dart';

class Registerpage extends StatelessWidget {
  Registerpage({super.key});
  final Color emerald = Color(0xFF046A38);
  final Color blackShade = const Color(0xFF1C1C1C);

  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPass = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: emerald, // optional background
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
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Name", Icons.person),
                  controller: _name,
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Email", Icons.email),
                  controller: _email,
                ),
                const SizedBox(height: 16),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator(
                    "Username",
                    Icons.account_circle,
                  ),
                  controller: _username,
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator("Password", Icons.lock),
                  controller: _password,
                ),
                const SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: CustomeInputDecorator(
                    "Confirm password",
                    Icons.lock,
                  ),
                  controller: _confirmPass,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 365,
                  child: ModernButton(
                    text: "Register",
                    emerald: emerald,
                    blackShade: blackShade,
                    onPressed: () async {
                      HapticFeedback.lightImpact();
                      // Handle register
                      bool success = false; //change

                      if (_formKey.currentState!.validate()) {
                        //success = await loginUser(_username.text, _password.text);
                      }
                      if (success) {
                        // handle success
                        Navigator.pushNamed(context, '/home');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              "Registration failed. Please try again.",
                              style: TextStyle(color: Color(0xFFFFFFFF)),
                            ),
                            duration: const Duration(seconds: 5),
                            backgroundColor: blackShade,
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
