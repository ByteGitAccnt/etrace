import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Color emerald = Color(0xFF046A38);
  final Color blackShade = const Color(0xFF1C1C1C);

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: emerald, // optional background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
              ],
          ),
        ),
      ),
    );
  }
}