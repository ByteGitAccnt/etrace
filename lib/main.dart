import 'package:etrace/HomePage.dart';
import 'package:etrace/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:etrace/RegisterPage.dart';

//inal Color emeraldDark = const Color(0xFF046A38);
// final Color emeraldLight = const Color(0xFF2EBB57);
// final Color blackShade = const Color(0xFF1C1C1C);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login', // 👈 start here
      onGenerateRoute: (settings) {
        late Widget page;
        switch (settings.name) {
          case '/login':
            page = LoginPage();
            break;
          case '/register':
            page = Registerpage();
            break;
          case '/home':
          page = HomePage();
            break;
          default:
            page = HomePage();
        }
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(
            milliseconds: 250,
          ), // 👈 shorter = faster
          reverseTransitionDuration: const Duration(milliseconds: 250),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // slide from right
            const end = Offset.zero;
            const curve = Curves.fastOutSlowIn;
            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Project App',
      theme: ThemeData(primarySwatch: Colors.green),
      // The home widget will be connected by you
      home: LoginPage(),
    );
  }
}
